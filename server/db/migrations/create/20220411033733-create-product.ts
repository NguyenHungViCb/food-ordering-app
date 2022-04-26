import { QueryInterface, Sequelize, DataTypes } from "sequelize";
import validate from "../../../utils/validations/modelValidation";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("products", {
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
      created_at: {
        allowNull: false,
        type: DataTypes.DATE,
      },
      updated_at: {
        allowNull: false,
        type: DataTypes.DATE,
      },
    });
  },
  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.dropTable("products");
  },
};
