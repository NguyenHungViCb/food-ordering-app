import Product from "../../models/product";
import ProductImage from "../../models/product/image";
import { getAttributes } from "../../utils/modelUtils";
import { imagePlainObj } from "../image";

export class ProductModel {
  constructor(public name: string, public price: number) {}
}

export class ProductCreation extends ProductModel {
  constructor(
    public name: string,
    public price: number,
    public id: number,
    public description: string,
    public original_price: number,
    public stock: number,
    public order_count: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(name, price);
  }
}

export const productSchemaPlainObj = {
  ...getAttributes(Product),
  images: [getAttributes(ProductImage)],
};
export const productModelPlainObj = getAttributes(Product, [
  "name",
  "original_price",
]);
export const productCreationPlainObj = getAttributes(Product, [
  { attribute: "description", optional: true },
  { attribute: "price", optional: true },
  { attribute: "stock", optional: true },
]);
export const createdProductResponsePayload = {
  ...productModelPlainObj,
  images: [imagePlainObj],
  ...productCreationPlainObj,
  categories: "number[]",
};
