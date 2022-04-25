import { NextFunction, Request, Response } from "express";
import Cart from "../../models/cart";

const cartValidate = async (req: Request, _: Response, next: NextFunction) => {
  const { user } = req;
  const existCart = await Cart.findOrCreate({
    where: { user_id: user.getDataValue("id"), is_active: true },
    limit: 1,
  });
  req.cart = existCart[0];
  next();
};

export { cartValidate };
