import { DataTypes, Model } from "sequelize";
import Voucher from ".";
import { modelConfig, sequelize } from "../../db/config";
import Product from "../product";

const VoucherDetail = sequelize.define(
  "VoucherDetail",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    voucher_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Voucher,
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
  },
  modelConfig("voucher_details")
);

Product.belongsToMany(Voucher, {
  through: VoucherDetail,
});

Voucher.belongsToMany(Product, {
  through: VoucherDetail,
});

export default VoucherDetail;
