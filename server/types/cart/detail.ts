class ClassDetailModel {
  constructor(
    public cart_id: number,
    public product_id: number,
    public quantity: number
  ) {}
}

class ClassDetailCreation extends ClassDetailModel {
  public constructor(
    public id: number,
    public cart_id: number,
    public product_id: number,
    public quantity: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(cart_id, product_id, quantity);
  }
}

export { ClassDetailModel, ClassDetailCreation };
