import { green } from "colors";
import { NextFunction, Request, Response } from "express";
import { Model } from "sequelize";
import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import Product from "../../models/product";
import Voucher from "../../models/voucher";
import { CartCreation } from "../../types/cart";
import { CartDetailCreation } from "../../types/cart/detail";
import { ProductCreation } from "../../types/product/productInterface";
import { queryToNum } from "../../utils/validations/assertions";

type CartWithDetailWithProduct = Model<
  CartCreation & {
    cart_details: Array<CartDetailCreation & { product: ProductCreation }>;
  },
  any
>;

const getOrderTotal = async (req: Request, _: Response, next: NextFunction) => {
  console.log(green("Get order total"));
  let cart_id;
  if (req.method.toLowerCase() === "get") {
    cart_id = req.query.cart_id;
  } else {
    cart_id = req.body.cart_id;
  }
  const cartId = queryToNum(cart_id, () => {
    throw new Error("cart_id is required");
  });
  const cart = await Cart.findByPk(cartId, {
    include: [
      {
        model: CartDetail,
        as: "cart_details",
        include: [
          {
            model: Product,
            as: "product",
          },
        ],
      },
    ],
  });
  if (!cart) {
    throw new Error("Cart not found");
  }
  // Calculate cart total
  let total = 0;
  for (const item of (cart as CartWithDetailWithProduct).getDataValue(
    "cart_details"
  )) {
    total += item.product.price * item.quantity;
  }
  req.body.total = total;
  req.cart = cart;
  next();
};

const voucherApply = async (req: Request, _: Response, next: NextFunction) => {
  const { voucher } = req.body;
  if (!voucher) {
    next();
  }
  const existVoucher = await Voucher.findByPk(voucher);
  if (!existVoucher) {
    throw new Error("Voucher not founded");
  }
  req.body.total -=
    (req.body.total * existVoucher.getDataValue("discount")) / 100;
  next();
};

export { getOrderTotal, voucherApply };
