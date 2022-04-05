import { NextFunction, Request, Response } from "express";
import CategoryDetail from "../../models/categoryDetail";
import Product from "../../models/product";
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
    const products = await Product.findAndCountAll();
    return res
      .status(200)
      .json({ message: "success", data: products, success: true });
  }

  @routeDescription({
    request_payload: {
      ...productModelPlainObj,
      ...productCreationPlainObj,
      categories: "number[]",
    },
    response_payload: productSchemaPlainObj,
    usage: "create a single product",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createOne(req: Request, res: Response, __: NextFunction) {
    let { categories, ...rest } = req.body;
    requireValues({ ...req.body });

    const categoryIds = validate<Array<number>>(
      categories,
      "categories"
    ).isArray().value;

    const product = await Product.create({
      ...rest,
    });
    for (const categoryId of categoryIds) {
      await CategoryDetail.create({
        product_id: product.get("id"),
        category_id: categoryId,
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
