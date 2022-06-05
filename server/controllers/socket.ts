import http from "http";
import { Server, Socket } from "socket.io";
import { DefaultEventsMap } from "socket.io/dist/typed-events";
import { green } from "colors";
import { extractTokenFromHeader } from "../middlewares/auths/tokenExtractStrategies";
import { Model } from "sequelize";
import { UserCreation, UserModel } from "../types/user/userInterfaces";
import { JWT_SECRET } from "../utils/AppConfig";
import { jwtTokenVerify, socketJwtValidate } from "../middlewares/auths";
import User from "../models/user";

class RootSocket {
  private static _instance: RootSocket;
  private _socket:
    | Socket<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>
    | undefined;

  static get socket() {
    return this._instance._socket;
  }

  private constructor() {}

  public static initialize(server: http.Server): RootSocket {
    if (!RootSocket._instance) {
      const io = new Server(server, {
        cors: {
          origin: "*",
        },
      });
      RootSocket._instance = new RootSocket();
      io.use(socketJwtValidate);
      io.on("connection", (socket) => {
        console.log(socket._error);
        this._instance._socket = socket;
        console.log(green("A new client has connected"));
      });
    }
    return RootSocket._instance;
  }
}

export default RootSocket;
