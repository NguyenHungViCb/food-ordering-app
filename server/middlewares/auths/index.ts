import { green } from "colors";
import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { Model } from "sequelize/types";
import User from "../../models/user";
import { UserCreation, UserModel } from "../../types/user/userInterfaces";
import { JWT_SECRET, REFRESH_TOKEN_SECRET } from "../../utils/AppConfig";
import { extractTokenFromHeader } from "./tokenExtractStrategies";

async function jwtTokenVerify<T>(
  token: string,
  secret: string,
  callback: (decoded: JwtPayload) => Promise<T>
) {
  const decoded = jwt.verify(token, secret);
  if (typeof decoded === "string") {
    throw new Error("Invalid token");
  }
  return await callback(decoded);
}

export async function jwtValidate(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    let token = extractTokenFromHeader(req.headers);

    req.user = await jwtTokenVerify<
      Model<UserCreation, UserModel | UserCreation>
    >(token, JWT_SECRET, async (decoded) => {
      const user = await User.findOne({ where: { id: parseInt(decoded.id) } });
      if (!user) {
        throw Error("UnAuthorized. User not found");
      }
      return user;
    });
    next();
  } catch (error: any) {
    return res.status(400).json({ message: `UnAuthorized. ${error.message}` });
  }
}

export async function validateRefreshToken(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    let token = extractTokenFromHeader(req.headers);

    req.user = await jwtTokenVerify<
      Model<UserCreation, UserModel | UserCreation>
    >(token, REFRESH_TOKEN_SECRET, async (decoded) => {
      const user = await User.findOne({
        where: { id: parseInt(decoded.id) },
      });
      if (!user) {
        throw Error("UnAuthorized. User not found");
      }
      if (user.getDataValue("refresh_token") !== token) {
        throw Error("UnAuthorized. Invalid token");
      }

      return user;
    });
    return next();
  } catch (error: any) {
    return res.status(400).json({ message: `UnAuthorized. ${error.message}` });
  }
}
