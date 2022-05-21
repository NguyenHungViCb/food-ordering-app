import Category from "../../models/category";
import { getAttributes } from "../../utils/modelUtils";

export class CategoryModel {
  constructor(public name: string) {}
}

export class CategoryCreation extends CategoryModel {
  constructor(
    public id: number,
    public name: string,
    public description: string,
    public images: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(name);
  }
}

export const categoryPlainObj = getAttributes(Category);
export const categoryModelPlainObj = getAttributes(Category, ["name"]);
export const categoryCreationPlainObj = getAttributes(Category, [
  "description",
]);
