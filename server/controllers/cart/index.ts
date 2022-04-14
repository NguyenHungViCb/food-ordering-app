import { NextFunction, Request, Response } from "express";
import { Model } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";
import { sequelize } from "../../db/config";
import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import { CartCreation, CartModel, createdCartPayload } from "../../types/cart";
import { getAttributes } from "../../utils/modelUtils";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { isArray, isNotNull } from "../../utils/validations/assertions";
import { requireValues } from "../../utils/validations/modelValidation";
import Product from "../../models/product";

interface createPayloadType {
  product_id: number;
  quantity: number;
}

const path = "/carts";
@controller
class CartController {
  @routeDescription({
    request_payload: [getAttributes(CartDetail, ["product_id", "quantity"])],
    response_payload: createdCartPayload,
    isAuth: true,
    usage:
      "Create a single cart, shouldn't be used directly, use addToCart instead",
  })
  @routeConfig({
    method: "post",
    path: `${path}/create/single`,
    middlewares: [jwtValidate],
  })
  async createCart(req: Request, res: Response, __: NextFunction) {
    const { items } = req.body;
    const { user } = req;
    requireValues(items);
    isArray<Array<createPayloadType>>(items);
    isNotNull(user);

    const cart = await Cart.create<
      Model<CartCreation, CartModel | CartCreation | { cart_details: any }>
    >(
      { user_id: user.getDataValue("id"), cart_details: items },
      {
        include: [
          {
            model: CartDetail,
            as: "cart_details",
            attributes: { exclude: ["cart_id"] },
          },
        ],
      }
    );

    res.json({ data: cart, success: true });
  }

  @routeDescription({
    request_payload: [getAttributes(CartDetail, ["product_id", "quantity"])],
  })
  @routeConfig({
    method: "post",
    path: `${path}/items/add`,
    middlewares: [jwtValidate],
  })
  async addProductToCart(req: Request, res: Response, __: NextFunction) {
    const { items } = req.body;
    const { user } = req;
    const { cart } = req;
    requireValues(items);
    isArray<Array<createPayloadType>>(items);
    isNotNull(user);

    for (const item of items) {
      const product = await Product.findByPk(item.product_id);
      const detail = await CartDetail.update(
        { quantity: sequelize.literal(`quantity + ${item.quantity}`) },
        {
          where: {
            cart_id: cart.getDataValue("id"),
            product_id: item.product_id,
            quantity: sequelize.literal(
              `quantity + ${item.quantity} <= ${product?.getDataValue("id")}`
            ),
          },
        }
      );
      return res.json({ data: detail, success: true });
    }
  }
}

export default CartController;
