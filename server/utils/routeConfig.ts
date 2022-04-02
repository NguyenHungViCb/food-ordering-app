import { red } from "colors";
import { NextFunction, RequestHandler, Request, Response } from "express";
import app, { routeEvent } from "../server";

export type RouteConfig = {
  method: "post" | "get" | "delete" | "put";
  path: string;
  middlewares?: Array<RequestHandler>;
};

export const routeConfig = ({
  method,
  path,
  middlewares,
}: RouteConfig): MethodDecorator => {
  return (_: Object, __: string | symbol, descriptor: PropertyDescriptor) => {
    let handlers: Array<RequestHandler> = [];
    if (middlewares && middlewares.length > 0) {
      handlers = [...handlers, ...middlewares];
    }

    const response = async (
      req: Request,
      res: Response,
      next: NextFunction
    ) => {
      try {
        await descriptor.value(req, res, next);
      } catch (error: any) {
        console.log(error.message);
        res.status(500).json({ message: "some error occurred" });
      }
    };

    handlers = [...handlers, response];
    app[method](path, ...handlers);
    routeEvent.emit("update_route", { path, method, auth: false });
  };
};
