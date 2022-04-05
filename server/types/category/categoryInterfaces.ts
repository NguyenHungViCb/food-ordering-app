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
    public createdAt?: Date,
    public updatedAt?: Date
  ) {
    super(name);
  }
}

export const categoryPlainObj = getSchemaInPlainObj(Category.getAttributes());

const { name, description } = Category.getAttributes();
// @ts-ignore
export const categoryModelPlainObj = getSchemaInPlainObj({ name });
// @ts-ignore
export const categoryCreationPlainObj = getSchemaInPlainObj({ description }, true);
