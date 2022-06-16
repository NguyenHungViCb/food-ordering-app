import { NextFunction, Request, Response } from "express";
import { jwtValidate, validateRefreshToken } from "../../middlewares/auths";
import User from "../../models/user";
import {
  userCreationResponsePayload,
  UserModel,
} from "../../types/user/userInterfaces";
import { requireValues } from "../../utils/validations/modelValidation";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { generateRefreshToken, generateToken } from "../../utils/tokenUtils";
import { getAttributesData } from "../../utils/modelUtils";
import { updateIfExist } from "../../services";
import { attachExistCartToUser } from "../../middlewares/carts";

const path = "/users";
@controller
class UserController {
  async createUser(user: UserModel) {
    return await User.create(user);
  }

  @routeDescription({
    request_payload: {
      first_name: "string",
      last_name: "string",
      email: "string",
      password: "string",
    },
    response_payload: userCreationResponsePayload,
    usage: "signup using email and password",
  })
  @routeConfig({ method: "post", path: `${path}/signup/local` })
  async signUp(req: Request, res: Response, __: NextFunction) {
    const { password, cart_id, ...rest } = req.body;
    requireValues([...req.body]);
    const user = await this.createUser(rest);
    user.set("password", password);
    await user.save();
    await attachExistCartToUser(cart_id, user);
    const values = getAttributesData(user, [
      "id",
      "first_name",
      "last_name",
      "email",
      "email_verified",
      "phone_number",
      "birthday",
      "avatar",
      "active",
      "created_at",
      "updated_at",
    ]);
    return res.status(200).json({
      message: "created user",
      data: values,
      success: true,
    });
  }

  @routeDescription({
    request_payload: { email: "string", password: "string" },
    response_payload: { token: "string", refresh_token: "string" },
    usage: "login using email and password",
  })
  @routeConfig({ method: "post", path: `${path}/login/local` })
  async login(req: Request, res: Response, __: NextFunction) {
    const { cart_id, ...rest } = req.body;
    requireValues([...rest]);
    const user = await User.findOne({ where: { email: req.body.email } });
    if (user) {
      await attachExistCartToUser(cart_id, user);
      if (user.getDataValue("password") !== req.body.password) {
        throw new Error("UnAuthorized. Wrong email or password");
      }
      const token = generateToken({ id: user.getDataValue("id") });
      const refreshToken = generateRefreshToken({
        id: user.getDataValue("id"),
      });
      user.set("refresh_token", refreshToken);
      await user.save();
      return res.status(200).json({
        message: "login succeeded",
        data: { token, refresh_token: refreshToken },
        success: true,
      });
    } else {
      throw new Error("UnAuthorized. User not found");
    }
  }

  @routeDescription({
    response_payload: userCreationResponsePayload,
    usage: "get an user info (only that user can access his/ her info)",
    isAuth: true,
  })
  @routeConfig({
    method: "get",
    path: `${path}/auth/info/single`,
    middlewares: [jwtValidate],
  })
  async getInfo(req: Request, res: Response, __: NextFunction) {
    const values = getAttributesData(req.user, [
      "id",
      "first_name",
      "last_name",
      "email",
      "email_verified",
      "phone_number",
      "birthday",
      "avatar",
      "active",
      "created_at",
      "updated_at",
      "address",
    ]);
    return res.status(200).json({ data: values, success: true });
  }

  @routeConfig({
    method: "put",
    path: `${path}/auth/info/update/single`,
    middlewares: [jwtValidate],
  })
  async updateInfo(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { first_name, last_name, birthday, avatar, phone_number } = req.body;
    const updated = await updateIfExist(user, {
      first_name,
      last_name,
      birthday,
      avatar,
      phone_number,
    });
    const values = getAttributesData(updated, [
      "id",
      "first_name",
      "last_name",
      "email",
      "email_verified",
      "phone_number",
      "birthday",
      "avatar",
      "active",
      "created_at",
      "updated_at",
    ]);
    return res.json({
      message: "update succeeded",
      data: values,
      success: true,
    });
  }

  @routeDescription({
    response_payload: { token: "string", refresh_token: "string" },
    isAuth: true,
    usage: "refresh access and refresh token",
  })
  @routeConfig({
    method: "get",
    path: `${path}/auth/token/refresh`,
    middlewares: [validateRefreshToken],
  })
  async refreshToken(req: Request, res: Response, __: NextFunction) {
    const { id } = req.user.get();
    const token = generateToken({ id });
    const refreshToken = generateRefreshToken({ id });
    req.user.set("refresh_token", refreshToken);
    await req.user.save();
    return res.status(200).json({
      data: { token, refresh_token: refreshToken },
      success: true,
    });
  }

  @routeConfig({
    method: "post",
    path: `${path}/auth/addresses/update`,
    middlewares: [jwtValidate],
  })
  async addAddress(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { address, ward, district, city } = req.body;
    requireValues([address, ward, district, city]);
    const updatedAddress = await user.update({
      address: `${address}, ${ward}, ${district}, ${city}`,
    });
    return res.json({ data: updatedAddress, success: true });
  }
}

export default UserController;
