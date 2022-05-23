import { DataTypes, QueryInterface, Sequelize } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.addConstraint("order_details", {
      fields: ["order_id"],
      type: "foreign key",
      references: {
        table: "orders",
        field: "id",
      },
      onDelete: "cascade",
      onUpdate: "cascade",
    });
  },

  async down(queryInterface: QueryInterface, _: Sequelize) {},
};
