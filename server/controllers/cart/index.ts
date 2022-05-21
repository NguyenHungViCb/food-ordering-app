import { NextFunction, Request, Response } from "express";
import { Model } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";
import { sequelize } from "../../db/config";
import Cart from "../../models/cart";
import CartDetail from "../../models/cart/detail";
import {
  addItemsPayload,
  CartCreation,
  cartDetailItem,
  CartModel,
  createdCartPayload,
  removeItemsPayload,
} from "../../types/cart";
import { getAttributes } from "../../utils/modelUtils";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { isArray, isNotNull } from "../../utils/validations/assertions";
import { requireValues } from "../../utils/validations/modelValidation";
import Product from "../../models/product";
import {
  activeCartValidate,
  upsertActiveCartValidate,
} from "../../middlewares/carts";
import { upsert } from "../../services";
import { decreaseQuantity, increaseQuantity } from "../../services/cart/cart";
import { parseToJSON } from "../../utils/validations/json";
import { errorsConverter } from "../../utils/commons";

export interface createPayloadType {
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
      { user_id: user.getDataValue("id") },
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

  async addSingleProductToCart(
    item: createPayloadType,
    cart: Model<CartCreation, CartCreation | CartModel>
  ) {
    let failedInsert;
    let succeededInsert;
    const transaction = await sequelize.transaction();
    const product = await Product.findByPk(item.product_id, {
      transaction,
    });
    try {
      const [detail] = await upsert(CartDetail, {
        condition: {
          cart_id: cart.getDataValue("id"),
          product_id: item.product_id,
        },
        transaction,
      });
      succeededInsert = await increaseQuantity(
        detail,
        item.quantity,
        product?.getDataValue("stock") || 0,
        transaction
      );
      await transaction.commit();
    } catch (error: any) {
      // rollback if new updated quantity > stock
      failedInsert = {
        item,
        error: errorsConverter.jsonOrString(error.message),
      };
      await transaction.rollback();
    }
    return {
      succeededInsert: {
        value: succeededInsert,
        total:
          (succeededInsert?.getDataValue("quantity") || 0) *
          (product?.getDataValue("price") || 0),
      },
      failedInsert,
    };
  }

  @routeDescription({
    request_payload: [cartDetailItem],
    response_payload: [addItemsPayload],
    usage: "Add items to cart",
    isAuth: true,
  })
  @routeConfig({
    method: "post",
    path: `${path}/items/add`,
    middlewares: [jwtValidate, upsertActiveCartValidate],
  })
  async addProductsToCart(req: Request, res: Response, __: NextFunction) {
    const { items } = req.body;
    const { cart } = req;
    requireValues(items);
    isArray<createPayloadType>(items);

    const failedInserts = [];
    const succeededInserts = [];
    let total = 0;
    for (const item of items) {
      const result = await this.addSingleProductToCart(item, cart);
      if (result.succeededInsert) {
        succeededInserts.push(result.succeededInsert.value);
        total += result.succeededInsert.total;
      }
      if (result.failedInsert) {
        failedInserts.push(result.failedInsert);
      }
    }
    await cart.update({ total });
    return res.json({
      ...(failedInserts.length > 0
        ? { message: "The operation succeed with error" }
        : {}),
      data: {
        ...cart.get(),
        succeeded_inserts: succeededInserts,
        failed_inserts: failedInserts,
      },
      success: true,
    });
  }

  async removeSingleProductFromCart(
    item: Pick<createPayloadType, "product_id">,
    cart: Model<CartCreation, CartCreation | CartModel>
  ) {
    let succeededDeletes;
    let failedDeletes;
    try {
      succeededDeletes = await CartDetail.destroy({
        where: {
          cart_id: cart.getDataValue("id"),
          product_id: item.product_id,
        },
      });
    } catch (error: any) {
      failedDeletes = { item, error: error.message };
    }
    return { succeededDeletes, failedDeletes };
  }

  @routeDescription({
    request_payload: [{ ...cartDetailItem, quantity: "number" }],
    response_payload: [removeItemsPayload],
    isAuth: true,
    usage:
      "Remove items from cart, include quantity to decrease quantity, exclude quantity to remove item",
  })
  @routeConfig({
    method: "post",
    path: `${path}/items/remove`,
    middlewares: [jwtValidate, activeCartValidate],
  })
  async removeProductsFromCart(req: Request, res: Response, __: NextFunction) {
    const { items } = req.body;
    const { cart } = req;
    requireValues(items);
    const failedDeletes = [];
    const succeededDeletes = [];
    for (const item of items) {
      const transaction = await sequelize.transaction();
      try {
        const detail = await CartDetail.findOne({
          where: {
            cart_id: cart.getDataValue("id"),
            product_id: item.product_id,
          },
          transaction,
        });
        isNotNull(detail, "item", "not found");
        const currentQty = detail?.getDataValue("quantity");
        if (currentQty === 0 || !item.quantity) {
          await detail.destroy();
        } else if (item.quantity) {
          if (isNaN(parseInt(item.quantity))) {
            throw new Error("invalid quantity field");
          }
          const increased = await decreaseQuantity(
            detail,
            item.quantity,
            transaction
          );
          if (increased.getDataValue("quantity") === 0) {
            await increased.destroy({ transaction });
          }
          const product = await Product.findByPk(
            detail.getDataValue("product_id")
          );
          if (product) {
            await cart.update({
              total:
                detail.getDataValue("quantity") *
                product?.getDataValue("price"),
            });
          }
        }
        await transaction.commit();
        succeededDeletes.push(detail);
      } catch (error: any) {
        await transaction.rollback();
        failedDeletes.push({ item, error: parseToJSON(error.message) });
      }
    }

    return res.json({
      ...(failedDeletes.length > 0
        ? { message: "The operation succeed with error" }
        : {}),
      data: {
        ...cart.get(),
        succeeded_deletes: succeededDeletes,
        failed_deletes: failedDeletes,
      },
    });
  }

  @routeDescription({
    response_payload: {
      ...createdCartPayload,
      details: [createdCartPayload.details],
    },
  })
  @routeConfig({
    method: "get",
    path: `${path}/active`,
    middlewares: [jwtValidate],
  })
  async getActiveCart(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const cart = await Cart.findOne({
      where: { user_id: user.getDataValue("id") },
      include: [{ model: CartDetail, as: "cart_details" }],
    });
    if (cart) {
      return res.json({ data: cart, success: true });
    }
    return res
      .status(404)
      .json({ message: "No cart found", data: null, success: false });
  }
}

export default CartController;
