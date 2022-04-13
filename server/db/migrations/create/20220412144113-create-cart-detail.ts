import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("cart_details", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      cart_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "carts",
          },
          key: "id",
        },
        allowNull: false,
        onDelete: "cascade",
      },
      product_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "products",
          },
          key: "id",
        },
        allowNull: false,
        onDelete: "cascade",
      },
      quantity: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
        allowNull: false,
      },
      createdAt: {
        allowNull: false,
        type: DataTypes.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: DataTypes.DATE,
      },
    });
  },
  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.dropTable("cart_details");
  },
};
