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
import validate from "../../utils/validations/modelValidation";
import Product from "../../models/product";
import { productSchemaPlainObj } from "../../types/product/productInterface";

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

  @routeDescription({
    query: {
      ids: "[number]",
      "c_page?": "number",
      "c_lim?": "number",
    },
    response_payload: {
      count: "number",
      rows: [
        {
          ...categoryModelPlainObj,
          ...categoryCreationPlainObj,
          images: [imagePlainObj],
          products: [productSchemaPlainObj],
        },
      ],
    },
    usage: "get products of categories (default limit up to 10 categories)",
  })
  @routeConfig({ method: "get", path: `${path}/get/products` })
  async getProductsOfCategory(req: Request, res: Response, __: NextFunction) {
    const { ids, c_lim, c_page } = req.query;
    const cLim = c_lim && typeof c_lim === "string" ? parseInt(c_lim) : 10;
    const cPage = c_page && typeof c_page === "string" ? parseInt(c_page) : 0;
    if (ids && typeof ids === "string") {
      validate(JSON.parse(ids)).isTruthy().isArray();
      const category = await Category.findAndCountAll({
        where: { id: JSON.parse(ids) },
        offset: cPage * cLim,
        limit: cLim,
        include: [
          {
            model: Product,
            as: "products",
            through: { attributes: [] },
            include: [
              { model: Image, as: "images", through: { attributes: [] } },
            ],
          },
          { model: Image, as: "images", through: { attributes: [] } },
        ],
      });
      return res.json({ data: category, success: true });
    }
  }
}

export default CategoryController;
