import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import { createPayload, getAttributes } from "../../utils/modelUtils";

class CartModel {
  constructor(public user_id: number) {}
}

class CartCreation extends CartModel {
  constructor(
    public id: number,
    public user_id: number,
    public total: number,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(user_id);
  }
}

const details = getAttributes(CartDetail, [
  "id",
  "quantity",
  "product_id",
  "created_at",
  "updated_at",
]);

const cartDetailItem = getAttributes(CartDetail, [
  "product_id",
  { attribute: "quantity", optional: false },
]);

const createdCartPayload = {
  ...getAttributes(Cart),
  details,
};

const failedInsertType = {
  item: cartDetailItem,
  error: {
    message: "string",
    request: "number",
    stock: "number",
  },
};

const addItemsPayload = {
  ...createdCartPayload,
  succeeded_inserts: cartDetailItem,
  failed_inserts: failedInsertType,
};

const removeItemsPayload = {
  ...createPayload,
  succeeded_inserts: cartDetailItem,
  failedInsertType: `${{ ...failedInsertType }} | 'string'`,
};

export {
  CartModel,
  CartCreation,
  createdCartPayload,
  cartDetailItem,
  failedInsertType,
  addItemsPayload,
  removeItemsPayload,
};
