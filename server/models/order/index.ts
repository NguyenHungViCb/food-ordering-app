import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { OrderCreation, OrderModel, ORDER_STATUS } from "../../types/order";
import User from "../user";
import Voucher from "../voucher";
import OrderDetail from "./details";

const Order = sequelize.define<
  Model<OrderCreation, OrderCreation | OrderModel>
>(
  "Order",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.BIGINT,
      references: { model: User, key: "id" },
    },
    address: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM(...(Object.values(ORDER_STATUS) as string[])),
      allowNull: false,
    },
    payment_method: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    payment_detail: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    paid_at: {
      type: DataTypes.DATE,
    },
    canceled_at: {
      type: DataTypes.DATE,
    },
    voucher_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Voucher,
        key: "id",
      },
    },
  },
  modelConfig("orders")
);

Order.hasMany(OrderDetail, {
  as: "details",
  foreignKey: "order_id",
});

OrderDetail.belongsTo(Order, {
  as: 'details',
  foreignKey: "order_id"
})

export default Order;
