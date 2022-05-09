import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import User from "../user";
import Voucher from "../voucher";

const Order = sequelize.define(
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
      type: DataTypes.ENUM("pending", "failed", "succeed"),
      allowNull: false,
    },
    payment_method: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    paid_at: {
      type: DataTypes.DATE,
    },
    cancelled_at: {
      type: DataTypes.DATE,
    },
    voucher: {
      type: DataTypes.BIGINT,
      references: {
        model: Voucher,
        key: "id",
      },
    },
  },
  modelConfig("orders")
);

export default Order;
