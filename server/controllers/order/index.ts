import { NextFunction, Request, Response } from "express";
import { Op } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";
import Order from "../../models/order";
import OrderDetail from "../../models/order/details";
import Product from "../../models/product";
import User from "../../models/user";
import Voucher from "../../models/voucher";
import { isAllowTransitionState } from "../../services/order/state";
import { ORDER_STATUS } from "../../types/order";
import { stripe } from "../../utils/AppConfig";
import { imageToArray } from "../../utils/modelUtils";
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
    }).then((data) => ({
      ...data?.get(),
      status_history: data?.getDataValue("status_history")?.split(";"),
    }));
    let orderTotal = 0;
    if (onGoingOrder) {
      // @ts-ignore
      for (const item of onGoingOrder.details as any[]) {
        orderTotal += parseInt(item.total);
      }
      if (onGoingOrder.voucher_id) {
        const voucher = await Voucher.findByPk(onGoingOrder.voucher_id);
        if (voucher) {
          orderTotal -= (orderTotal * voucher.getDataValue("discount")) / 100;
        }
      }
      return res.json({
        data: { ...onGoingOrder, total: orderTotal },
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
    const currentStatus = order.getDataValue("status");
    if (!isAllowTransitionState(currentStatus, status)) {
      throw new Error(
        JSON.stringify({
          code: 422,
          message: `Invalid target state, order with state of ${order.getDataValue(
            "status"
          )} can't be transition to ${status}`,
        })
      );
    }
    const updatedOrder = await order?.update({
      status: status,
      status_history:
        order.getDataValue("status_history") +
        `; ${new Date()}-${status}`,
    });
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

  @routeConfig({
    method: "get",
    path: `${OrderController.path}/all`,
    middlewares: [jwtValidate],
  })
  async getAllOrder(_: Request, res: Response, __: NextFunction) {
    const order = await Order.findAndCountAll({
      include: [
        {
          model: OrderDetail,
          as: "details",
          include: [{ model: Product, as: "product" }],
        },
        {
          model: User,
          as: "user",
          attributes: ["first_name", "last_name", "email", "phone_number"],
        },
        {
          model: Voucher,
          as: "voucher",
        },
      ],
    }).then(({ rows, count }) => {
      return {
        rows: rows.map((row) => {
          let orderTotal = 0;
          if (row) {
            for (const item of row.get("details") as any[]) {
              orderTotal += parseInt(item.total);
            }
            // @ts-ignore
            if (row.getDataValue("voucher")) {
              orderTotal -=
                (orderTotal *
                  // @ts-ignore
                  row.getDataValue("voucher").getDataValue("discount")) /
                100;
            }
          }
          return { ...row.get(), total: orderTotal };
        }),
        count,
      };
    });
    return res.json({ data: order, success: true });
  }

  @routeConfig({
    method: "get",
    path: `${OrderController.path}/:id`,
    middlewares: [jwtValidate],
  })
  async getOrderById(req: Request, res: Response, __: NextFunction) {
    const { id } = req.params;
    if (id) {
      const requestedOrder = await Order.findByPk(id, {
        include: [
          {
            model: OrderDetail,
            as: "details",
            include: [{ model: Product, as: "product" }],
          },
          {
            model: User,
            as: "user",
            attributes: ["first_name", "last_name", "email", "phone_number"],
          },
          {
            model: Voucher,
            as: "voucher",
          },
        ],
      }).then((data) => {
        let orderTotal = 0;
        if (data) {
          for (const item of data.get("details") as any[]) {
            orderTotal += parseInt(item.total);
          }
          // @ts-ignore
          if (data.getDataValue("voucher")) {
            orderTotal -=
              (orderTotal *
                // @ts-ignore
                data.getDataValue("voucher").getDataValue("discount")) /
              100;
          }
          const transformedDetails = // @ts-ignore
            (data.getDataValue("details") as any[]).map((detail) => ({
              ...detail.get(),
              product: imageToArray(detail.getDataValue("product")),
            }));
          return {
            ...data.get(),
            status_history: data.getDataValue("status_history")?.split(";"),
            details: transformedDetails,
            total: orderTotal,
          };
        }
        return null;
      });
      return res.json({ data: requestedOrder, success: true });
    }
  }
}

export default OrderController;
