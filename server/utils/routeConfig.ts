import { NextFunction, RequestHandler, Request, Response } from "express";
import app, { routeEvent } from "../express";

export type RouteConfig = {
  method: "post" | "get" | "delete" | "put";
  path: string;
  middlewares?: Array<RequestHandler>;
};

const RouteSymbol = Symbol("RouteConfig");

export const routeConfig = ({
  method,
  path,
  middlewares,
}: RouteConfig): MethodDecorator => {
  return (
    target: any,
    propertyKey: string | symbol,
    descriptor: PropertyDescriptor
  ) => {
    target[RouteSymbol] = target[RouteSymbol] || new Map();
    target[RouteSymbol].set(propertyKey, {
      descriptor,
      method,
      path,
      middlewares,
    });
  };
};

export function controller<T extends { new (...args: any[]): {} }>(Base: T) {
  return class extends Base {
    constructor(...args: any[]) {
      super(...args);
      const routes = Base.prototype[RouteSymbol];
      if (routes) {
        routes.forEach(
          ({
            descriptor,
            method,
            path,
            middlewares,
          }: RouteConfig & { descriptor: PropertyDescriptor }) => {
            const handler: Array<RequestHandler> = [];
            const main = async (
              req: Request,
              res: Response,
              next: NextFunction
            ) => {
              try {
                await descriptor.value.apply(this, [req, res, next]);
              } catch (error: any) {
                res.json({ message: error.message, success: false });
              }
            };
            handler.push(main);
            if (middlewares && middlewares.length > 0) {
              handler.push(...middlewares);
            }
            routeEvent.emit("update_route", { path, method });
            app[method]("/api" + path, handler);
          }
        );
      }
    }
  };
}
