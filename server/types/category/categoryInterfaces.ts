import Category from "../../models/category";
import { getSchemaInPlainObj } from "../../utils/modelUtils";

export class CategoryModel {
  constructor(public name: string) {}
}

export class CategoryCreation extends CategoryModel {
  constructor(
    public id: number,
    public name: string,
    public description: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(name);
  }
}

export class CategoryDetailModel {
  constructor(public product_id: number, public category_id: number) {}
}

export class CategoryDetailCreation extends CategoryDetailModel {
  constructor(
    public id: number,
    public product_id: number,
    public category_id: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(product_id, category_id);
  }
}

export const categoryPlainObj = getSchemaInPlainObj(Category.getAttributes());

const { name, description } = Category.getAttributes();
export const categoryModelPlainObj = getSchemaInPlainObj({ name });
export const categoryCreationPlainObj = getSchemaInPlainObj(
  { description },
  true
);
