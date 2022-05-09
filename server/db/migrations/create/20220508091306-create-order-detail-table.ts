import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("order_details", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      order_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "orders",
          },
          key: "id",
        },
      },
      product_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "products",
          },
          key: "id",
        },
      },
      quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      price: {
        type: DataTypes.DECIMAL,
        allowNull: false,
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
    await queryInterface.dropTable("orders");
  },
};
