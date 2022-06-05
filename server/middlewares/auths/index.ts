import { green } from "colors";
import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { Model } from "sequelize/types";
import { Socket } from "socket.io";
import { ExtendedError } from "socket.io/dist/namespace";
import { DefaultEventsMap } from "socket.io/dist/typed-events";
import User from "../../models/user";
import { UserCreation, UserModel } from "../../types/user/userInterfaces";
import { JWT_SECRET, REFRESH_TOKEN_SECRET } from "../../utils/AppConfig";
import { extractTokenFromHeader } from "./tokenExtractStrategies";

export async function jwtTokenVerify<T>(
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
  _: Response,
  next: NextFunction
) {
  try {
    let token = extractTokenFromHeader(req.headers);

    req.user = await jwtTokenVerify<
      Model<UserCreation, UserModel | UserCreation>
    >(token, JWT_SECRET, async (decoded) => {
      const user = await User.findByPk(parseInt(decoded.id));
      if (!user) {
        throw Error("UnAuthorized. User not found");
      }
      return user;
    });
    next();
  } catch (error: any) {
    throw new Error(
      JSON.stringify({ code: 400, message: `UnAuthorized. ${error.message}` })
    );
    // return res.status(400).json({ message: `UnAuthorized. ${error.message}` });
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

export function tryMiddleware(
  middleware: (req: Request, res: Response, next: NextFunction) => Promise<any>,
  callback?: (req: Request, res: Response, next: NextFunction) => Promise<any>
) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await middleware(req, res, next);
    } catch (error) {
      await callback?.(req, res, next);
      next();
    }
  };
}

export async function socketJwtValidate(
  socket: Socket<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>,
  next: (err?: ExtendedError | undefined) => void
) {
  if (socket.handshake.headers) {
    try {
      let token = extractTokenFromHeader(socket.handshake.headers);
      await jwtTokenVerify<Model<UserCreation, UserModel | UserCreation>>(
        token,
        JWT_SECRET,
        async (decoded) => {
          const user = await User.findOne({
            where: { id: parseInt(decoded.id) },
          });
          if (!user) {
            throw Error("UnAuthorized. User not found");
          }
          return user;
        }
      );
      next();
    } catch (error: any) {
      console.log(error);
      next(new Error("UnAuthorized"));
    }
  }
}
