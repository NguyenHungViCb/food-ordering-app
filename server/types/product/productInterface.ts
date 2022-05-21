import Product from "../../models/product";
import { getAttributes } from "../../utils/modelUtils";

export class ProductModel {
  constructor(
    public name: string,
    public price: number,
    public category_id: number,
    public images: string
  ) {}
}

export class ProductCreation extends ProductModel {
  constructor(
    public name: string,
    public price: number,
    public id: number,
    public description: string,
    public original_price: number,
    public stock: number,
    public category_id: number,
    public images: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(name, price, category_id, images);
  }
}

export const productSchemaPlainObj = {
  ...getAttributes(Product),
  images: [{ src: "string" }],
};
export const productModelPlainObj = getAttributes(Product, [
  "name",
  "original_price",
]);
export const productCreationPlainObj = getAttributes(Product, [
  "name",
  "description",
  "original_price",
  { attribute: "stock", optional: true },
  "category_id",
]);
export const createdProductResponsePayload = {
  ...productModelPlainObj,
  images: [{ src: "string" }],
  ...productCreationPlainObj,
  categories: "number[]",
};
