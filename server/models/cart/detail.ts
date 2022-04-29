import { DataTypes, Model } from "sequelize";
import Cart from ".";
import { modelConfig, sequelize } from "../../db/config";
import { CartDetailCreation, CartDetailModel } from "../../types/cart/detail";
import Product from "../product";

const CartDetail = sequelize.define<
  Model<CartDetailCreation, CartDetailModel | CartDetailCreation>
>(
  "CartDetail",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    cart_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Cart,
        key: "id",
      },
      allowNull: false,
    },
    product_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Product,
        key: "id",
      },
      allowNull: false,
    },
    quantity: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
  },
  modelConfig("cart_details")
);

Cart.hasMany(CartDetail, {
  as: "cart_details",
  onDelete: "cascade",
  foreignKey: "cart_id",
});
CartDetail.belongsTo(Cart, {
  as: "cart",
  foreignKey: "cart_id",
});

export default CartDetail;
