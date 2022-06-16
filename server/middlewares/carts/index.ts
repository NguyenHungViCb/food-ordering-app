import { green, red } from "colors";
import { NextFunction, Request, Response } from "express";
import { Model } from "sequelize";
import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import { UserCreation, UserModel } from "../../types/user/userInterfaces";
import { queryToNum } from "../../utils/validations/assertions";

const activeCartValidate = async (
  req: Request,
  _: Response,
  next: NextFunction
) => {
  const { user } = req;
  const existCart = await Cart.findOne({
    where: { user_id: user.getDataValue("id") },
  });
  if (!existCart) {
    console.log(red("THROW"));
    throw new Error(
      JSON.stringify({
        code: 404,
        message: "this user has no active cart",
      })
    );
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
            JSON.stringify({ code: 404, message: "Cart not found" })
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

const getUnAuthCart = async (req: Request, _: Response, next: NextFunction) => {
  const { cart_id } = req.query;
  if (cart_id) {
    const cartId = queryToNum(cart_id);
    const existCart = await Cart.findByPk(cartId);
    if (!existCart) {
      throw new Error(JSON.stringify({ code: 404, message: "Cart not found" }));
    }
    req.cart = existCart;
    next();
  } else {
    throw new Error(JSON.stringify({ code: 400, message: "Cart not found" }));
  }
};

const getUnAuthCartDecorator = (
  middleware: (...args: any[]) => Promise<any>
) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    const { user } = req;
    if (user) {
      await middleware(req, res, next);
    } else {
      await getUnAuthCart(req, res, next);
    }
  };
};

const attachExistCartToUser = async (
  cartId: string | number,
  user: Model<UserCreation, UserModel | UserCreation>
) => {
  console.log(green("CartId"));
  const existCart = await Cart.findByPk(cartId);
  if (existCart) {
    const userCart = await Cart.findOne({
      where: { user_id: user.getDataValue("id") },
    });
    if (
      userCart &&
      userCart.getDataValue("id") !== existCart.getDataValue("id")
    ) {
      await CartDetail.update(
        { cart_id: userCart.getDataValue("id") },
        { where: { cart_id: existCart.getDataValue("id") } }
      );
    } else if (!userCart) {
      console.log({ userId: user.getDataValue("id") });
      await Cart.update(
        { user_id: user.getDataValue("id") },
        { where: { id: existCart.getDataValue("id") } }
      );
    }
  }
};

export {
  upsertActiveCartValidate,
  activeCartValidate,
  unAuthCartDecorator,
  getUnAuthCart,
  getUnAuthCartDecorator,
  attachExistCartToUser,
};
