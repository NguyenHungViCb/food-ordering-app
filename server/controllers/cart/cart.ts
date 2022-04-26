import { Model, Transaction } from "sequelize";
import { CartDetailCreation, CartDetailModel } from "../../types/cart/detail";

const increaseQuantity = async (
  detail: Model<CartDetailCreation, CartDetailCreation | CartDetailModel>,
  quantity: number,
  max: number,
  transaction?: Transaction
) => {
  if (detail.getDataValue("quantity") + quantity <= max) {
    return await detail.increment({ quantity: quantity }, { transaction });
  } else {
    throw new Error(
      JSON.stringify({
        message: "exceed quantity",
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
