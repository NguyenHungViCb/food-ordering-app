class CategoryImageModel {
  constructor(public category_id: number, public image_id: number) {}
}

class CategoryImageCreation extends CategoryImageModel {
  constructor(
    public id: number,
    public category_id: number,
    public image_id: number
  ) {
    super(category_id, image_id);
  }
}

export { CategoryImageModel, CategoryImageCreation };
