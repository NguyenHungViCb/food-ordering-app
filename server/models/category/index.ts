import { DataTypes, Model } from "sequelize";
import { sequelize } from "../../db/config";
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
    description: {
      type: DataTypes.STRING,
    },
  },
  { tableName: "categories", timestamps: true }
);

Category.sync({ alter: true });

export default Category;
