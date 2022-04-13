import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.createTable("category_images", {
      id: {
        type: DataTypes.BIGINT,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
      category_id: {
        type: DataTypes.BIGINT,
        references: {
          model: {
            tableName: "categories",
          },
          key: "id",
        },
        field: "category_id",
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
    await queryInterface.dropTable("category_images");
  },
};
