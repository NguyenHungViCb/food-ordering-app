import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("orders", "status_history");
    await queryInterface.addColumn("orders", "status_history", {
      type: DataTypes.TEXT("long"),
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("orders", "status_history");
  },
};
