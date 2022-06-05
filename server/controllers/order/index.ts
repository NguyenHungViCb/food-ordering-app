import { NextFunction, Request, Response } from "express";
import { Op } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";
import Order from "../../models/order";
import OrderDetail from "../../models/order/details";
import Voucher from "../../models/voucher";
import { isAllowTransitionState } from "../../services/order/state";
import { ORDER_STATUS } from "../../types/order";
import { stripe } from "../../utils/AppConfig";
import { controller, routeConfig } from "../../utils/routeConfig";
import RootSocket from "../socket";

@controller
class OrderController {
  static path = "/orders";

  @routeConfig({
    method: "get",
    path: `${OrderController.path}/ongoing`,
    middlewares: [jwtValidate],
  })
  async getOnGoingOrder(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const onGoingOrder = await Order.findOne({
      where: {
        user_id: user.getDataValue("id"),
        status: { [Op.notIn]: [ORDER_STATUS.canceled, ORDER_STATUS.succeeded] },
      },
      include: [{ model: OrderDetail, as: "details" }],
    });
    let orderTotal = 0;
    if (onGoingOrder) {
      for (const item of onGoingOrder.get("details") as any[]) {
        orderTotal += parseInt(item.total);
      }
      if (onGoingOrder.getDataValue("voucher_id")) {
        const voucher = await Voucher.findByPk(
          onGoingOrder.getDataValue("voucher_id")
        );
        if (voucher) {
          orderTotal -= (orderTotal * voucher.getDataValue("discount")) / 100;
        }
      }
      return res.json({
        data: { ...onGoingOrder.get(), total: orderTotal },
        success: true,
      });
    }
    return res.json({ success: true });
  }

  @routeConfig({
    method: "put",
    path: `${OrderController.path}/status/update`,
    middlewares: [jwtValidate],
  })
  async updateOrderStatus(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { status } = req.body;
    const order = await Order.findOne({
      where: {
        user_id: user.getDataValue("id"),
        status: { [Op.notIn]: [ORDER_STATUS.canceled, ORDER_STATUS.succeeded] },
      },
    });
    if (!order) {
      throw new Error("Order not found");
    }
    if (!isAllowTransitionState(order.getDataValue("status"), status)) {
      throw new Error(
        JSON.stringify({
          code: 422,
          message: `Invalid target state, order with state of ${order.getDataValue(
            "status"
          )} can't be transition to ${status}`,
        })
      );
    }

    const updatedOrder = await order?.update({ status: status });
    if (updatedOrder.getDataValue("status") === ORDER_STATUS.canceled) {
      const paymentIntents = await stripe.charges.search({
        query: `metadata['order']:'${order.getDataValue("id")}'`,
      });
      await stripe.refunds.create({
        payment_intent: paymentIntents.data[0].payment_intent! as string,
      });
      await updatedOrder.update({ canceled_at: new Date() });
    }
    RootSocket.socket?.emit(
      `ORDER_UPDATE_STATUS`,
      updatedOrder?.getDataValue("status")
    );
    return res.json({ data: order, success: true });
  }
}

export default OrderController;
