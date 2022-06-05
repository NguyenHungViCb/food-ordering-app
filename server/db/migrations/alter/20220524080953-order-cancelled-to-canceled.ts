import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("orders", "cancelled_at");
    await queryInterface.addColumn("orders", "canceled_at", {
      type: DataTypes.STRING,
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("orders", "canceled_at");
    await queryInterface.addColumn("orders", "cancelled_at", {
      type: DataTypes.STRING,
    });
  },
};
