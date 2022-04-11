class ProductImageModel {
  constructor(public product_id: number, public image_id: number) {}
}

class ProductImageCreation extends ProductImageModel {
  constructor(
    public id: number,
    public product_id: number,
    public image_id: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(product_id, image_id);
  }
}

export { ProductImageModel, ProductImageCreation };
