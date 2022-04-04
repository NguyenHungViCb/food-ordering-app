import { NextFunction, Request, Response } from "express";
import Category from "../../models/category";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";

const createCategoryPayload = {
  message: "string",
  success: "boolean",
};

const path = "/categories";
@controller
class CategoryController {
  @routeDescription({
    response_payload: createCategoryPayload,
    request_payload: {
      name: "string",
      description: "string",
      products: "number[]",
    },
    usage: "create a single product",
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
      return res.json({ category });
    }
  }
}

export default CategoryController;
