import { NextFunction, Request, Response } from "express";
import Category from "../../models/category";
// import CategoryImage from "../../models/category/image";
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
import validate from "../../utils/validations/modelValidation";
import Product from "../../models/product";
import { productSchemaPlainObj } from "../../types/product/productInterface";
import { isArray } from "../../utils/validations/assertions";
import { imageToArray } from "../../utils/modelUtils";

const path = "/categories";
@controller
class CategoryController {
  @routeDescription({
    response_payload: { ...categoryPlainObj, images: [{ src: "string" }] },
    request_payload: {
      ...categoryModelPlainObj,
      ...categoryCreationPlainObj,
      images: [{ src: "string" }],
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
      isArray<{ src: string }>(images);
      const category = await Category.create({
        name,
        description,
        images: images.reduce((prev, curr) => prev + curr.src + ";", ""),
      });
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
          images: [{ src: "string" }],
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
          },
        ],
      }).then((data) => ({
        rows: data.rows.map((row) => imageToArray(row)),
        count: data.count,
      }));
      return res.json({ data: category, success: true });
    } else {
      const categories = await Category.findAndCountAll({
        offset: cPage * cLim,
        limit: cLim,
        include: [
          {
            model: Product,
            as: "products",
          },
        ],
      }).then((data) => ({
        row: data.rows.map((row) => imageToArray(row)),
        count: data.count,
      }));
      return res.json({ data: categories, success: true });
    }
  }
}

export default CategoryController;
