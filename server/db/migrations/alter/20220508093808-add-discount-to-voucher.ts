import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.addColumn("vouchers", "discount", {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.removeColumn("vouchers", "discount");
  },
};
