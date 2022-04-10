import { NextFunction, Request, Response } from "express";
import Category from "../../models/category";
import Product from "../../models/product";
import ProductImage from "../../models/product/image";
import { createWithTransaction } from "../../services/";
import { ProductImageModel } from "../../types/product/image";
import {
  productCreationPlainObj,
  productModelPlainObj,
  productSchemaPlainObj,
} from "../../types/product/productInterface";
import validate, { requireValues } from "../../utils/modelValidation";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import ProductBase from "./product";

const path = "/products";
@controller
class ProductController extends ProductBase {
  @routeDescription({
    query: { categories: "number[]" },
    response_payload: {
      count: "number",
      rows: [productSchemaPlainObj],
    },
    usage: "get a list of every products",
  })
  @routeConfig({ method: "get", path: `${path}/get/all` })
  async getProductList(req: Request, res: Response, __: NextFunction) {
    if (req.query.categories && typeof req.query.categories === "string") {
      const categories = JSON.parse(req.query.categories);
      const products = await Product.findAndCountAll({
        include: [
          {
            model: Category,
            required: true,
            as: "categories",
            attributes: [],
            through: { where: { category_id: categories } },
          },
          {
            model: ProductImage,
            as: "images",
          },
        ],
      });
      return res.json({ message: "success", data: products, success: true });
    } else if (!req.query.categories) {
      const products = await Product.findAndCountAll({
        include: [{ model: ProductImage, as: "images" }],
      });
      return res
        .status(200)
        .json({ message: "success", data: products, success: true });
    } else {
      throw new Error("categories must be string type");
    }
  }

  @routeDescription({
    request_payload: {
      ...productModelPlainObj,
      images: [
        { src: "string", "type?": "string", "ratio?": "portrait | landscape" },
      ],
      ...productCreationPlainObj,
      categories: "number[]",
    },
    response_payload: productSchemaPlainObj,
    usage: "create a single product",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createOne(req: Request, res: Response, __: NextFunction) {
    let { categories, images, ...rest } = req.body;
    requireValues({ ...req.body });
    const imageArr = validate<Array<Pick<ProductImageModel, "src">>>(
      images,
      "images"
    ).isArray().value;

    const categoryIds = validate<Array<number>>(
      categories,
      "categories"
    ).isArray().value;

    const {
      createdEntity: product,
      callbackValues,
      error,
    } = await createWithTransaction(
      Product,
      { values: rest },
      async (product, transaction) => {
        const createdImages = await this.createWithImage(
          imageArr,
          product,
          transaction
        );
        await this.createWithCategoryId(categoryIds, product, transaction);
        return createdImages;
      }
    );
    if (error) {
      throw new Error(error);
    }

    return res.json({
      data: { product, images: callbackValues },
      success: true,
    });
  }

  @routeDescription({
    request_payload: { id: "number" },
    usage: "delete a single product",
  })
  @routeConfig({ method: "delete", path: `${path}/delete/single` })
  async deleteOne(req: Request, res: Response, __: NextFunction) {
    let { id } = req.body;
    await Product.destroy({ where: { id: id } });
    return res.status(200).json({ message: "deleted product", success: true });
  }
}

export default ProductController;
