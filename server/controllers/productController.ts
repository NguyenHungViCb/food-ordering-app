import { NextFunction, Request, Response } from "express";
import { routeConfig } from "../utils/routeConfig";

class ProductController {
  @routeConfig({ method: "get", path: "/product/list" })
  async getProductList(_: Request, res: Response, __: NextFunction) {
    res.json({ message: "success" });
  }
}

export default ProductController;
