class ProductImageModel {
  constructor(public product_id: number, public src: string) {}
}

class ProductImageCreation extends ProductImageModel {
  constructor(
    public id: number,
    public product_id: number,
    public src: string,
    public type: string,
    public ratio: "landscape" | "portrait",
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(product_id, src);
  }
}

export { ProductImageModel, ProductImageCreation };
