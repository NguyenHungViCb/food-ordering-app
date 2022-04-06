import { UserModel, UserCreation } from "./types/user/userInterfaces";
import { Model } from "sequelize";

declare global {
  namespace Express {
    interface Request {
      id: string;
      user: Model<UserCreation, UserCreation | UserModel>;
    }
  }
}
