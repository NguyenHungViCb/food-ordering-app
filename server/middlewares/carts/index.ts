import { NextFunction, Request, Response } from "express";
import Cart from "../../models/cart";
import { queryToNum } from "../../utils/validations/assertions";

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

const unAuthCartDecorator = (middleware: (...args: any[]) => Promise<any>) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    const { user } = req;
    if (user) {
      await middleware(req, res, next);
    } else {
      const { cart_id } = req.query;
      if (cart_id && typeof cart_id === "string") {
        const existCart = await Cart.findByPk(queryToNum(cart_id));
        if (!existCart) {
          throw new Error(
            JSON.stringify({ code: 404, message: "Cart not founded" })
          );
        }
        req.cart = existCart;
        next();
      } else {
        const newCart = await Cart.create();
        req.cart = newCart;
        next();
      }
    }
  };
};

export { upsertActiveCartValidate, activeCartValidate, unAuthCartDecorator };
