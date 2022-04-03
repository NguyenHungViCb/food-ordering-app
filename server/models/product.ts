import { DataTypes, Model } from "sequelize";
import { sequelize } from "../db/config";
import {
  ProductCreation,
  ProductModel,
} from "../types/product/productInterface";
import validate from "../utils/modelValidation";

const Product = sequelize.define<
  Model<ProductCreation, ProductModel | ProductCreation>
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
    order_count: {
      type: DataTypes.INTEGER(),
      allowNull: false,
      defaultValue: 0,
    },
  },
  { timestamps: true, tableName: "products" }
);

Product.sync({ alter: true });

export default Product;
