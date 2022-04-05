import { NextFunction, Request, Response } from "express";
import Category from "../../models/category";
import { categoryCreationPlainObj, categoryModelPlainObj, categoryPlainObj } from "../../types/category/categoryInterfaces";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";

const path = "/categories";
@controller
class CategoryController {
  @routeDescription({
    response_payload: {...categoryPlainObj},
    request_payload: {...categoryModelPlainObj, ...categoryCreationPlainObj },
    usage: "create a single category",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createCategory(req: Request, res: Response, __: NextFunction) {
    const { name, description, products } = req.body;
    if (products) {
      if (Array.isArray(products)) {
      } else {
        return res.json({
          message: "products must be an array",
          success: false,
        });
      }
    } else {
      const category = await Category.create({ name, description });
      return res.json({ data: category, success: true });
    }
  }
}

export default CategoryController;
