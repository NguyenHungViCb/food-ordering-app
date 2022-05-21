import { NextFunction, Request, Response } from "express";
import Product from "../../models/product";
import {
  productCreationPlainObj,
  productSchemaPlainObj,
} from "../../types/product/productInterface";
import { requireValues } from "../../utils/validations/modelValidation";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { isArray } from "../../utils/validations/assertions";
import { imageToArray } from "../../utils/modelUtils";

const path = "/products";
@controller
class ProductController {
  @routeDescription({
    response_payload: {
      count: "number",
      rows: [productSchemaPlainObj],
    },
    usage: "get a list of every products",
  })
  @routeConfig({ method: "get", path: `${path}/all` })
  async getProductList(_: Request, res: Response, __: NextFunction) {
    const products = await Product.findAndCountAll().then((data) => ({
      rows: data.rows.map((item) => imageToArray(item)),
      count: data.count,
    }));
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
      const product = await Product.findByPk(parseInt(id)).then((data) => {
        if (!data) {
          return data;
        }
        return imageToArray(data);
      });
      return res.json(product);
    }
    throw new Error("id must be a number");
  }

  @routeDescription({
    request_payload: { ...productCreationPlainObj, images: "string[]" },
    response_payload: productSchemaPlainObj,
    usage: "create a single product",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createOne(req: Request, res: Response, __: NextFunction) {
    let { images, ...rest } = req.body;
    isArray<{ src: string }>(images);
    requireValues(req.body);
    const reducedImages = images.reduce((prev, curr) => {
      return prev + ";" + curr.src;
    }, "");
    const product = await Product.create({
      ...rest,
      images: reducedImages,
      original_price: rest.original_price,
    });
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
