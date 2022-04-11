import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, Sequelize: Sequelize) {
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
    await queryInterface.dropTable("product_images");
  },
};
