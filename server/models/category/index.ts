import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import {
  CategoryCreation,
  CategoryModel,
} from "../../types/category/categoryInterfaces";

const Category = sequelize.define<
  Model<CategoryCreation, CategoryModel | CategoryCreation>
>(
  "Category",
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
    images: {
      type: DataTypes.STRING,
    },
    description: {
      type: DataTypes.STRING,
    },
  },
  modelConfig("categories")
);

export default Category;
