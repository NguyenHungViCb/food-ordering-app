import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import {
  CategoryDetailCreation,
  CategoryDetailModel,
} from "../../types/category/categoryInterfaces";
import Product from "../product";
import Category from "./index";

const CategoryDetail = sequelize.define<
  Model<CategoryDetailCreation, CategoryDetailModel | CategoryDetailCreation>
>(
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
  as: "products",
});

export default CategoryDetail;
