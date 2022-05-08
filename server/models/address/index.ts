import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { AddressModel, AddressCreation } from "../../types/address";
import User from "../user";

const Address = sequelize.define<
  Model<AddressCreation, AddressModel | AddressCreation>
>(
  "Address",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.BIGINT,
      references: {
        model: User,
        key: "id",
      },
      allowNull: false,
    },
    address: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    ward: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    district: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    city: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    is_primary: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  },
  modelConfig("addresses")
);

User.hasMany(Address, {
  as: "addresses",
  onDelete: "cascade",
  foreignKey: "user_id",
});
Address.belongsTo(User, {
  as: "user",
  foreignKey: "user_id",
});

export default Address;
