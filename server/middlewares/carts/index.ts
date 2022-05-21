import { NextFunction, Request, Response } from "express";
import Cart from "../../models/cart";

const activeCartValidate = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { user } = req;
  const existCart = await Cart.findOne({
    where: { user_id: user.getDataValue("id") },
  });
  if (!existCart) {
    return res.status(404).json({
      message: "this user has no active cart",
      data: null,
      success: false,
    });
  }
  req.cart = existCart;
  next();
};

const upsertActiveCartValidate = async (
  req: Request,
  _: Response,
  next: NextFunction
) => {
  const { user } = req;
  const existCart = await Cart.findOrCreate({
    where: { user_id: user.getDataValue("id") },
    limit: 1,
  });
  req.cart = existCart[0];
  next();
};

export { upsertActiveCartValidate, activeCartValidate };
