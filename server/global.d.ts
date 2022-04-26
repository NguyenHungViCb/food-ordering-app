import { UserModel, UserCreation } from "./types/user/userInterfaces";
import { Model } from "sequelize";
import { CartCreation, CartModel } from "./types/cart";

declare global {
  namespace Express {
    interface Request {
      id: string;
      user: Model<UserCreation, UserCreation | UserModel>;
      cart: Model<CartCreation, CartCreation | CartModel>;
    }
  }
}
