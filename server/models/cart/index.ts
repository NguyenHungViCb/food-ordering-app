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
  },
  modelConfig("carts")
);

User.hasMany(Cart, {
  as: "carts",
  onDelete: "cascade",
  onUpdate: "cascade",
});
Cart.belongsTo(User, {
  as: "carts",
});

export default Cart;
