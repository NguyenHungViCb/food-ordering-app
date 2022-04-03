import { NextFunction, Request, Response } from "express";
import CategoryDetail from "../models/categoryDetail";
import Product from "../models/product";
import validate, { requireValues } from "../utils/modelValidation";
import { controller, routeConfig } from "../utils/routeConfig";

const path = "/products";
@controller
class ProductController {
  @routeConfig({ method: "get", path: `${path}/all` })
  async getProductList(_: Request, res: Response, __: NextFunction) {
    res.json({ message: "success" });
  }

  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createProduct(req: Request, res: Response, __: NextFunction) {
    let { categories, ...rest } = req.body;
    requireValues({ ...req.body });

    const newCategories = validate<Array<any>>(
      categories,
      "categories"
    ).isArray().value;

    const product = await Product.create({
      ...rest,
    });
    for (const category of newCategories) {
      await CategoryDetail.create({
        product_id: product.get("id"),
        category_id: category,
      });
    }
    return res.json({ product });
  }
}

export default ProductController;
