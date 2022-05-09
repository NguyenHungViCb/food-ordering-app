import { DataTypes, Model } from "sequelize";
import Order from ".";
import { modelConfig, sequelize } from "../../db/config";
import Product from "../product";

const OrderDetail = sequelize.define(
  "OrderDetail",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    order_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Order,
        key: "id",
      },
    },
    product_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Product,
        key: "id",
      },
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    price: {
      type: DataTypes.DECIMAL,
      allowNull: false,
    },
  },
  modelConfig("order_details")
);

export default OrderDetail;
