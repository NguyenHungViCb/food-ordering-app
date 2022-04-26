import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.addColumn("carts", "is_active", {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("carts", "is_active");
  },
};
