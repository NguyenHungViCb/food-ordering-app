import { DataTypes, Model } from "sequelize";
import Cart from ".";
import { modelConfig, sequelize } from "../../db/config";
import { ClassDetailCreation, ClassDetailModel } from "../../types/cart/detail";
import Product from "../product";

const CartDetail = sequelize.define<
  Model<ClassDetailCreation, ClassDetailModel | ClassDetailCreation>
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
      allowNull: false,
    },
  },
  modelConfig("cart_detail")
);

Cart.hasMany(CartDetail, {
  as: "cart_details",
  onDelete: "cascade",
});
CartDetail.belongsTo(Cart, {
  as: "cart_details",
});

export default CartDetail;
