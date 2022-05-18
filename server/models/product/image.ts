import { DataTypes, Model } from "sequelize";
import Product from ".";
import { modelConfig, sequelize } from "../../db/config";
import {
  ProductImageCreation,
  ProductImageModel,
} from "../../types/product/image";
import Image from "../image";

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
    image_id: {
      type: DataTypes.BIGINT,
      references: {
        model: Image,
        key: "id",
      },
      field: "image_id",
    },
  },
  { ...modelConfig("product_images") }
);

Product.belongsToMany(Image, {
  through: ProductImage,
  onDelete: "cascade",
  as: "images",
  foreignKey: "product_id",
});
Image.belongsToMany(Product, {
  through: ProductImage,
  onDelete: "cascade",
  as: "product",
  foreignKey: "image_id",
});

export default ProductImage;
