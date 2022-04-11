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

ProductImage.sync({ alter: true });
Product.belongsToMany(Image, {
  through: ProductImage,
  onDelete: "cascade",
  as: "images",
});
Image.belongsToMany(Product, {
  through: ProductImage,
  onDelete: "cascade",
});
// This should only be run when we change the table
// And it should not be used at all
// Need to find other way
// ProductImage.sync({ force: true });

export default ProductImage;
