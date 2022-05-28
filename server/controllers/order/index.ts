import { NextFunction, Request, Response } from "express";
import { Op } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";
import Order from "../../models/order";
import OrderDetail from "../../models/order/details";
import { ORDER_STATUS } from "../../types/order";
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
    return res.json({ data: onGoingOrder?.get(), success: true });
  }

  @routeConfig({
    method: "post",
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
    if (!Object.values(ORDER_STATUS).includes(status)) {
      throw new Error("Not a valid status");
    }
    const updatedOrder = await order?.update({ status: status });
    RootSocket.socket?.emit(
      `ORDER_UPDATE_STATUS`,
      updatedOrder?.getDataValue("status")
    );
    return res.json({ data: updatedOrder, success: true });
  }
}

export default OrderController;
