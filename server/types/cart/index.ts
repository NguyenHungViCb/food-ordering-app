import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import { getAttributes } from "../../utils/modelUtils";

class CartModel {
  constructor(public user_id: number) {}
}

class CartCreation extends CartModel {
  constructor(
    public id: number,
    public user_id: number,
    public is_active: boolean,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(user_id);
  }
}

const createdCartPayload = {
  ...getAttributes(Cart),
  details: getAttributes(CartDetail, [
    "id",
    "quantity",
    "product_id",
    "created_at",
    "updated_at",
  ]),
};

export { CartModel, CartCreation, createdCartPayload };
