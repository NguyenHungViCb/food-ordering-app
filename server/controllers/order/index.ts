import { green } from "colors";
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
import { queryToNum } from "../../utils/validations/assertions";
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
    console.log(green("RUN"));
    const { user } = req;
    const onGoingOrder = await Order.findOne({
      where: {
        user_id: user.getDataValue("id"),
        status: { [Op.notIn]: [ORDER_STATUS.canceled, ORDER_STATUS.succeeded] },
      },
      include: [
        { model: OrderDetail, as: "details" },
        { model: Voucher, as: "voucher" },
      ],
    }).then((data) => ({
      ...data?.get(),
      status_history: data?.getDataValue("status_history")?.split(";"),
    }));
    let originalTotal = 0;
    let orderTotal = 0;
    if (onGoingOrder) {
      // @ts-ignore
      for (const item of onGoingOrder.details as any[]) {
        originalTotal += parseInt(item.total);
      }
      if (onGoingOrder.voucher_id) {
        const voucher = await Voucher.findByPk(onGoingOrder.voucher_id);
        if (voucher) {
          orderTotal =
            originalTotal -
            (originalTotal * voucher.getDataValue("discount")) / 100;
        }
      } else {
        orderTotal = originalTotal;
      }
      return res.json({
        data: {
          ...onGoingOrder,
          original_total: originalTotal,
          total: orderTotal,
          allowCancel:
            onGoingOrder.status !== ORDER_STATUS.shipping &&
            isAllowTransitionState(onGoingOrder.status!, ORDER_STATUS.canceled),
        },
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
    const { status, order_id, user_id } = req.body;
    const order = await Order.findByPk(order_id);
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
        order.getDataValue("status_history") + `; ${new Date()}-${status}`,
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
      `ORDER_UPDATE_STATUS_${user_id}`,
      updatedOrder?.getDataValue("status")
    );
    return res.json({ data: order, success: true });
  }

  @routeConfig({
    method: "get",
    path: `${OrderController.path}/all`,
    middlewares: [jwtValidate],
  })
  async getAllOrder(req: Request, res: Response, __: NextFunction) {
    const { user_id, limit, page } = req.query;
    const l = queryToNum(limit, () => {});
    const p = queryToNum(page, () => {});
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
      ...(user_id ? { where: { user_id: parseInt(user_id.toString()) } } : {}),
      ...(limit ? { limit: l } : {}),
      ...(page ? { offset: l * p } : {}),
    }).then(({ rows, count }) => {
      return {
        rows: rows.map((row) => {
          let originalTotal = 0;
          let orderTotal = 0;
          let totalItem = 0;
          if (row) {
            for (const item of row.get("details") as any[]) {
              originalTotal += parseInt(item.total);
              totalItem += item.quantity;
            }
            // @ts-ignore
            if (row.getDataValue("voucher")) {
              orderTotal =
                originalTotal -
                (originalTotal *
                  // @ts-ignore
                  row.getDataValue("voucher").getDataValue("discount")) /
                  100;
            } else {
              orderTotal = originalTotal;
            }
          }
          return {
            ...row.get(),
            total: orderTotal,
            original_total: originalTotal,
            total_items: totalItem,
          };
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
            attributes: [
              "first_name",
              "last_name",
              "email",
              "phone_number",
              "id",
            ],
          },
          {
            model: Voucher,
            as: "voucher",
          },
        ],
      }).then((data) => {
        let orderTotal = 0;
        let originalTotal = 0;
        if (data) {
          for (const item of data.get("details") as any[]) {
            originalTotal += parseInt(item.total);
          }
          // @ts-ignore
          if (data.getDataValue("voucher")) {
            orderTotal =
              originalTotal -
              (originalTotal *
                // @ts-ignore
                data.getDataValue("voucher").getDataValue("discount")) /
                100;
          } else {
            orderTotal = originalTotal;
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
            original_total: originalTotal,
          };
        }
        return null;
      });
      return res.json({ data: requestedOrder, success: true });
    }
  }
}

export default OrderController;
