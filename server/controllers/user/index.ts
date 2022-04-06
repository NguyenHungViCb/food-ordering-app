import { NextFunction, Request, Response } from "express";
import { jwtValidate } from "../../middlewares/auths";
import User from "../../models/user";
import {
  userCreationResponsePayload,
  UserModel,
} from "../../types/user/userInterfaces";
import { requireValues } from "../../utils/modelValidation";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { generateRefreshToken, generateToken } from "../../utils/tokenUtils";

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
  @routeConfig({ method: "post", path: `${path}/auth/signup/local` })
  async signUp(req: Request, res: Response, __: NextFunction) {
    const { password, ...rest } = req.body;
    requireValues([...req.body]);
    const user = await this.createUser(rest);
    user.set("password", password);
    await user.save();
    return res
      .status(200)
      .json({ message: "created user", data: user, success: true });
  }

  @routeDescription({
    request_payload: { email: "string", password: "string" },
    response_payload: { token: "string", refresh_token: "string" },
    usage: "login using email and password",
  })
  @routeConfig({ method: "post", path: `${path}/auth/login/local` })
  async login(req: Request, res: Response, __: NextFunction) {
    requireValues([...req.body]);
    const user = await User.findOne({ where: { email: req.body.email } });
    if (user) {
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
    usage: "get an user info(only that user can access his/ her info)",
  })
  @routeConfig({
    method: "get",
    path: `${path}/auth/info/single`,
    middlewares: [jwtValidate],
  })
  async getInfo(req: Request, res: Response, __: NextFunction) {
    const { first_name, last_name, email, email_verified } = req.user.get();
    return res.status(200).json({
      first_name,
      last_name,
      email,
      email_verified,
    });
  }
}

export default UserController;
