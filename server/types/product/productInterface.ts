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
