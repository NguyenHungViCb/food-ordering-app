import { Model, Transaction } from "sequelize";
import { CartDetailCreation, CartDetailModel } from "../../types/cart/detail";

const increaseQuantity = async (
  detail: Model<CartDetailCreation, CartDetailCreation | CartDetailModel>,
  quantity: number,
  max: number,
  transaction?: Transaction
) => {
  const m = Math.min(10, max);
  if (quantity >= 1 && detail.getDataValue("quantity") + quantity <= m) {
    return await detail.increment({ quantity: quantity }, { transaction });
  } else {
    throw new Error(
      JSON.stringify({
        message: m === max ? "exceed quantity" : "You can only add 10 item or less",
        request: detail.getDataValue("quantity") + quantity,
        stock: max,
      })
    );
  }
};

const decreaseQuantity = async (
  detail: Model<CartDetailCreation, CartDetailCreation | CartDetailModel>,
  quantity: number,
  transaction?: Transaction
) => {
  if (detail.getDataValue("quantity") - quantity >= 0) {
    return await detail.decrement({ quantity: quantity }, { transaction });
  } else {
    throw new Error(
      JSON.stringify({
        message:
          "quantity must greater or equal to 0, remove quantity field if you want to remove product",
        request: detail.getDataValue("quantity") - quantity,
        min: 0,
      })
    );
  }
};

export { increaseQuantity, decreaseQuantity };
