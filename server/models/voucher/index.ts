import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { VoucherCreation, VoucherModel } from "../../types/voucher";

const Voucher = sequelize.define<
  Model<VoucherCreation, VoucherModel | VoucherCreation>
>(
  "Voucher",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    code: {
      type: DataTypes.STRING,
      validate: {
        max: 12,
      },
      allowNull: false,
      unique: true,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    discount: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    valid_from: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    valid_until: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  },
  modelConfig("vouchers")
);

export default Voucher;
