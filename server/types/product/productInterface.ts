import Product from "../../models/product";
import ProductImage from "../../models/product/image";
import { getSchemaInPlainObj } from "../../utils/modelUtils";

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

const {
  id: imageId,
  product_id,
  src,
  ...imageRest
} = ProductImage.getAttributes();

export const productSchemaPlainObj = {
  ...getSchemaInPlainObj(Product.getAttributes()),
  images: [
    {
      // @ts-ignore
      ...getSchemaInPlainObj({ id: imageId, product_id, src }),
      // @ts-ignore
      ...getSchemaInPlainObj(imageRest, true),
    },
  ],
};
const {
  id,
  created_at,
  updated_at,
  order_count,
  name,
  original_price,
  ...rest
} = Product.getAttributes();
// @ts-ignore
export const productModelPlainObj = getSchemaInPlainObj({
  name,
  original_price,
});
// @ts-ignore
export const productCreationPlainObj = getSchemaInPlainObj(rest, true);
