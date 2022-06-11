import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import {
  ProductCreation,
  ProductModel,
} from "../../types/product/productInterface";
import validate from "../../utils/validations/modelValidation";
import Category from "../category";

const Product = sequelize.define<
  Model<ProductCreation, ProductCreation | ProductModel>
>(
  "Product",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    price: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      defaultValue: 0,
      validate: {
        isPositive(value: number) {
          validate(value, "price").isPostive();
        },
      },
    },
    original_price: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      defaultValue: 0,
      validate: {
        isPositive(value: number) {
          validate(value, "price").isPostive();
        },
      },
    },
    stock: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
      validate: {
        isPositive(value: number) {
          validate(value, "price").isPostive();
        },
      },
    },
    category_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Category,
      },
      key: "id",
    },
    images: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  { ...modelConfig("products") }
);

Product.belongsTo(Category, {
  as: "products",
  foreignKey: "id",
});
Category.hasMany(Product, {
  as: "products",
  foreignKey: "category_id",
});
export default Product;
