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
    const { name, price, categories } = req.body;
    try {
      requireValues({ name, price, categories });
      validate(categories, "categories").isArray();
      const product = await Product.create({ name: name, price: price });
      for (const category of categories) {
        await CategoryDetail.create({
          product_id: product.get("id"),
          category_id: category,
        });
      }
      res.json({ product });
    } catch (error: any) {
      res.json({ message: error.message, success: false });
    }
  }
}

export default ProductController;
