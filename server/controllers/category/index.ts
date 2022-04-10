import { NextFunction, Request, Response } from "express";
import Category from "../../models/category";
import CategoryImage from "../../models/category/image";
import {
  categoryCreationPlainObj,
  categoryModelPlainObj,
  categoryPlainObj,
} from "../../types/category/categoryInterfaces";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import Image from "../../models/image";
import { imagePlainObj } from "../../types/image";

const path = "/categories";
@controller
class CategoryController {
  @routeDescription({
    response_payload: { ...categoryPlainObj, images: [imagePlainObj] },
    request_payload: {
      ...categoryModelPlainObj,
      ...categoryCreationPlainObj,
      images: [imagePlainObj],
    },
    usage: "create a single category",
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createCategory(req: Request, res: Response, __: NextFunction) {
    const { name, description, products, images } = req.body;
    if (products) {
      if (Array.isArray(products)) {
      } else {
        return res.json({
          message: "products must be an array",
          success: false,
        });
      }
    } else {
      const category = await Category.create(
        // @ts-ignore
        { name, description, images: images },
        {
          include: [
            {
              model: Image,
              required: true,
              as: "images",
              through: CategoryImage,
            },
          ],
        }
      );
      return res.json({ data: category, success: true });
    }
  }
}

export default CategoryController;
