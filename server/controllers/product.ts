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
  async createOne(req: Request, res: Response, __: NextFunction) {
    let { categories, ...rest } = req.body;
    requireValues({ ...req.body });

    const categoryIds = validate<Array<any>>(categories, "categories").isArray()
      .value;

    const product = await Product.create({
      ...rest,
    });
    for (const categoryId of categoryIds) {
      await CategoryDetail.create({
        product_id: product.get("id"),
        category_id: categoryId,
      });
    }
    return res.json({ product });
  }

  @routeConfig({ method: "delete", path: `${path}/delete/single` })
  async deleteOne(req: Request, res: Response, __: NextFunction) {
    let { id } = req.body;
    await Product.destroy({ where: { id: id } });
    return res.status(200).json({ message: "deleted product", success: true });
  }
}

export default ProductController;
