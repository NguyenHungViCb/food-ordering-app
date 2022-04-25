import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { CartCreation, CartModel } from "../../types/cart";
import User from "../user";

const Cart = sequelize.define<Model<CartCreation, CartModel | CartCreation>>(
  "Cart",
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
      field: "user_id",
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
  },
  modelConfig("carts")
);

User.hasMany(Cart, {
  as: "user",
  onDelete: "cascade",
  onUpdate: "cascade",
  foreignKey: "user_id",
});
Cart.belongsTo(User, {
  as: "user",
  foreignKey: "user_id",
});

export default Cart;
