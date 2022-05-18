import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("orders", "cart_id");
    await queryInterface.removeColumn("orders", "address");
    await queryInterface.addColumn("orders", "address", {
      type: DataTypes.STRING,
      allowNull: false,
    });
    await queryInterface.addColumn("orders", "voucher", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "vouchers",
        },
        key: "id",
      },
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.addColumn("orders", "cart_id", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "orders",
        },
        key: "id",
      },
    });
    await queryInterface.removeColumn("orders", "address");
    await queryInterface.addColumn("orders", "address", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "addresses",
        },
        key: "id",
      },
    });
    await queryInterface.removeColumn("ordres", "voucher");
  },
};
