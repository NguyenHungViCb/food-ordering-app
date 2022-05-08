import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("voucher_details", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      voucher_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "vouchers",
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
    await queryInterface.dropTable("voucher_details");
  },
};
