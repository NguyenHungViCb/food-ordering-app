import { Model, Transaction } from "sequelize";
import { CartDetailCreation, CartDetailModel } from "../../types/cart/detail";

const increaseQuantity = async (
  detail: Model<CartDetailCreation, CartDetailCreation | CartDetailModel>,
  quantity: number,
  max: number,
  transaction: Transaction
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

export { increaseQuantity };
