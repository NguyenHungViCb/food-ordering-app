import { NextFunction, Request, Response } from "express";
import Product from "../../models/product";
import ProductImage from "../../models/product/image";
import {
  createdProductResponsePayload,
  productSchemaPlainObj,
} from "../../types/product/productInterface";
import { requireValues } from "../../utils/validations/modelValidation";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import ProductBase from "./product";
import Image from "../../models/image";
import { ImageModel } from "../../types/image";
import { isArray } from "../../utils/validations/assertions";

const path = "/products";
@controller
class ProductController extends ProductBase {
  @routeDescription({
    response_payload: {
      count: "number",
      rows: [productSchemaPlainObj],
    },
    usage: "get a list of every products",
  })
  @routeConfig({ method: "get", path: `${path}/all` })
  async getProductList(_: Request, res: Response, __: NextFunction) {
    const products = await Product.findAndCountAll({
      include: [
        {
          model: Image,
          as: "images",
          through: {
            attributes: [],
          },
        },
      ],
    });
    return res
      .status(200)
      .json({ message: "success", data: products, success: true });
  }

  @routeDescription({
    // query: { id: "number" },
    response_payload: productSchemaPlainObj,
    usage: "get a single product by id",
  })
  @routeConfig({ method: "get", path: `${path}/:id` })
  async getSingle(req: Request, res: Response, __: NextFunction) {
    const { id } = req.params;
    if (id && typeof id === "string") {
      const product = await Product.findByPk(parseInt(id), {
        include: [{ model: Image, as: "images", through: { attributes: [] } }],
      });
      return res.json(product);
    }
    throw new Error("id must be a number");
  }

  @routeDescription({
    request_payload: createdProductResponsePayload,
    response_payload: productSchemaPlainObj,
    usage: "create a single product",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createOne(req: Request, res: Response, __: NextFunction) {
    let { categories, images, ...rest } = req.body;
    requireValues(req.body);
    isArray<Array<Pick<ImageModel, "src">>>(images, "images");
    isArray<Array<number>>(categories, categories);

    const product = await Product.create(
      { ...rest, images: images, original_price: rest.original_price },
      {
        include: [
          {
            model: Image,
            required: true,
            as: "images",
            // @ts-ignore
            through: ProductImage,
          },
        ],
      }
    );
    const { errors } = await this.createWithCategoryId(categories, product);
    if (errors.length > 0) {
      return res.json({
        data: product,
        success: true,
        message: "Product has been created with some error",
      });
    }
    return res.json({ data: product, success: true });
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
