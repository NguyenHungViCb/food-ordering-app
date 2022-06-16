import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("orders", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "users",
          },
          key: "id",
        },
      },
      address: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      status: {
        type: DataTypes.ENUM(
          "pending",
          "canceled",
          "succeeded",
          "confirmed",
          "processing",
          "shipping"
        ),
        allowNull: false,
      },
      status_history: {
        type: DataTypes.TEXT,
      },
      payment_method: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      payment_detail: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      paid_at: {
        type: DataTypes.DATE,
      },
      canceled_at: {
        type: DataTypes.DATE,
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
