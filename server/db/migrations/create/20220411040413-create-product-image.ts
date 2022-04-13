import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("product_images", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      product_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "products",
          },
          key: "id",
        },
        field: "product_id",
        onDelete: "cascade",
      },
      image_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "images",
          },
          key: "id",
        },
        field: "image_id",
        onDelete: "cascade",
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
    await queryInterface.dropTable("product_images");
  },
};
