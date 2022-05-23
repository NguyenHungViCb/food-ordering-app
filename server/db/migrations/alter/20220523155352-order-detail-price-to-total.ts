import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("order_details", "price");
    await queryInterface.addColumn("order_details", "total", {
      type: DataTypes.DECIMAL,
      defaultValue: 0,
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("order_details", "total");
    await queryInterface.addColumn("order_details", "price", {
      type: DataTypes.DECIMAL,
      defaultValue: 0,
    });
  },
};
