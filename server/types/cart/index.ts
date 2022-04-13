class CartModel {
  constructor(public user_id: number) {}
}

class CartCreation extends CartModel {
  constructor(
    public id: number,
    public user_id: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(user_id);
  }
}

export { CartModel, CartCreation };
