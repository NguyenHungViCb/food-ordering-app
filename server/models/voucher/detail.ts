import { DataTypes, Model } from "sequelize";
import Voucher from ".";
import { modelConfig, sequelize } from "../../db/config";
import { VoucherDetailCreation, VoucherDetailModel } from "../../types/voucher";
import Product from "../product";

const VoucherDetail = sequelize.define<
  Model<VoucherDetailCreation, VoucherDetailCreation | VoucherDetailModel>
>(
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
  as: "vouchers",
  foreignKey: "product_id",
});
Voucher.belongsToMany(Product, {
  through: VoucherDetail,
  as: "products",
  foreignKey: "voucher_id",
});
Voucher.hasMany(VoucherDetail, {
  as: "details",
  foreignKey: "voucher_id",
});
VoucherDetail.belongsTo(Voucher, {
  as: "details",
  foreignKey: "voucher_id",
});

export default VoucherDetail;
