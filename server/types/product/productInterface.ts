import Product from "../../models/product";
import {getSchemaInPlainObj} from "../../utils/modelUtils";

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
    public createdAt?: Date,
    public updatedAt?: Date
  ) {
    super(name, price);
  }
}

export const productSchemaPlainObj = getSchemaInPlainObj(Product.rawAttributes);
const { id, createdAt, updatedAt, order_count, name, price, ...rest } =
  Product.getAttributes();
// @ts-ignore
export const productModelPlainObj = getSchemaInPlainObj({ name, price });
// @ts-ignore
export const productCreationPlainObj = getSchemaInPlainObj(rest, true);
