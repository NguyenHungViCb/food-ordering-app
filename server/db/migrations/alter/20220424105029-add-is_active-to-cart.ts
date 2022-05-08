import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    const description = await queryInterface.describeTable("carts");
    if (!description.is_active) {
      await queryInterface.addColumn("carts", "is_active", {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      });
    }
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("carts", "is_active");
  },
};
