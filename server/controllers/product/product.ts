import { Model, Transaction } from "sequelize";
import CategoryDetail from "../../models/category/detail";
import ProductImage from "../../models/product/image";
import { ProductImageModel } from "../../types/product/image";
import {
  ProductCreation,
  ProductModel,
} from "../../types/product/productInterface";

export default class ProductBase {
  // async createWithImage(
  //   images: Pick<ProductImageModel, "src">[],
  //   product: Model<ProductCreation, ProductCreation | ProductModel>,
  //   transaction?: Transaction
  // ) {
  //   let createdImages = [];
  //   for (const image of images) {
  //     const createdImage = await ProductImage.create(
  //       { ...image, product_id: product.getDataValue("id") },
  //       { transaction }
  //     );
  //     createdImages.push(createdImage);
  //   }
  //   return createdImages;
  // }

  async createWithCategoryId(
    categoryIds: number[],
    product: Model<ProductCreation, ProductCreation | ProductModel>,
    transaction?: Transaction
  ) {
    let errors: any[] = [];
    let createdDetails = [];
    for (const categoryId of categoryIds) {
      try {
        const createdDetail = await CategoryDetail.create(
          {
            product_id: product.getDataValue("id"),
            category_id: categoryId,
          },
          { transaction }
        );
        createdDetails.push(createdDetail);
      } catch (error: any) {
        errors.push(error);
      }
    }
    return { createdDetails, errors };
  }
}
