import { DataTypes } from "sequelize";
import { sequelize } from "../db/config";
import Product from "./product";
import Category from "./category";

const CategoryDetail = sequelize.define(
  "CategoryDetail",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    product_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Product,
        key: "id",
      },
      allowNull: false,
    },
    category_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Category,
        key: "id",
      },
      allowNull: false,
    },
  },
  { tableName: "category_details" }
);

// Category.belongsToMany(Product, { through: CategoryDetail, otherKey: "category_id" });
// Product.belongsToMany(Category, { through: CategoryDetail, otherKey: "product_id" });
CategoryDetail.sync({ alter: true });

export default CategoryDetail;
