import { DataTypes } from "sequelize";
import { sequelize } from "../db/config";

const Category = sequelize.define(
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
  { tableName: "categories" }
);

Category.sync({ alter: true });

export default Category;
