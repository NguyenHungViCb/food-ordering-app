import { QueryInterface, Sequelize, DataTypes } from "sequelize";

module.exports = {
  async up(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.changeColumn("product_images", "product_id", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "products",
        },
      },
      allowNull: false,
      onDelete: "cascade",
    });
    await queryInterface.changeColumn("product_images", "image_id", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "images",
        },
      },
      allowNull: false,
      onDelete: "cascade",
    });
  },
  async down(queryInterface: QueryInterface, _: Sequelize) {
    await queryInterface.changeColumn("product_images", "product_id", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "products",
        },
      },
      allowNull: false,
    });
    await queryInterface.changeColumn("product_images", "image_id", {
      type: DataTypes.BIGINT,
      references: {
        model: {
          tableName: "products",
        },
      },
      allowNull: false,
    });
  },
};
