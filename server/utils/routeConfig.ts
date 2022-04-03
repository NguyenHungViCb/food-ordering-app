import { NextFunction, RequestHandler, Request, Response } from "express";
import app, { routeEvent } from "../server";

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
    let handlers: Array<RequestHandler> = [];
    if (middlewares && middlewares.length > 0) {
      handlers = [...handlers, ...middlewares];
    }
    target[RouteSymbol] = target[RouteSymbol] || new Map();
    target[RouteSymbol].set(propertyKey, { descriptor, method, path });
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
          }: RouteConfig & { descriptor: PropertyDescriptor }) => {
            const handler = async (
              req: Request,
              res: Response,
              next: NextFunction
            ) => {
              await descriptor.value.apply(this, [req, res, next]);
            };
            app[method](path, handler);
          }
        );
      }
    }
  };
}
