import { DataTypes } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import Product from "../product";
import Category from "./index";

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
  modelConfig("category_details")
);

Product.belongsToMany(Category, {
  through: CategoryDetail,
  onDelete: "cascade",
  as: "categories",
});
Category.belongsToMany(Product, {
  through: CategoryDetail,
  onDelete: "cascade",
});
CategoryDetail.sync({ alter: true });

export default CategoryDetail;
