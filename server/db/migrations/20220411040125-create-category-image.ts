import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, Sequelize: Sequelize) {
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
  async down(queryInterface: QueryInterface, Sequelize: Sequelize) {
    await queryInterface.dropTable("category_images");
  },
};
