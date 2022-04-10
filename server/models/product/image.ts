import { DataTypes, Model } from "sequelize";
import Product from ".";
import { modelConfig, sequelize } from "../../db/config";
import {
  ProductImageCreation,
  ProductImageModel,
} from "../../types/product/image";

const ProductImage = sequelize.define<
  Model<ProductImageCreation, ProductImageModel | ProductImageCreation>
>(
  "ProductImage",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    product_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Product,
        key: "id",
      },
      field: "product_id",
    },
    src: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING,
    },
    ratio: {
      type: DataTypes.ENUM("landscape", "portrait"),
    },
  },
  { ...modelConfig("product_images") }
);

ProductImage.belongsTo(Product, {
  foreignKey: "product_id",
  onUpdate: "cascade",
  onDelete: "cascade",
  as: "product",
});
Product.hasMany(ProductImage, {
  foreignKey: "product_id",
  onUpdate: "cascade",
  onDelete: "cascade",
  as: "images",
});
// This should only be run when we change the table
// And it should not be used at all
// Need to find other way
// ProductImage.sync({ force: true });

export default ProductImage;
