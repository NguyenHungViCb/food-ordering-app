import { NextFunction, RequestHandler, Request, Response } from "express";
import app, { routeEvent } from "../express";

export type RouteConfig = {
  method: "post" | "get" | "delete" | "put";
  path: string;
  middlewares?: Array<RequestHandler>;
};

const RouteSymbol = Symbol("RouteConfig");

export const routeConfig = (config: RouteConfig): MethodDecorator => {
  return (
    target: any,
    propertyKey: string | symbol,
    descriptor: PropertyDescriptor
  ) => {
    target[RouteSymbol] = target[RouteSymbol] || new Map();
    if (target[RouteSymbol].get(propertyKey)) {
      target[RouteSymbol].set(propertyKey, {
        descriptor,
        propertyKey,
        ...config,
        ...target[RouteSymbol].get(propertyKey),
      });
    } else {
      target[RouteSymbol].set(propertyKey, {
        descriptor,
        propertyKey,
        ...config,
      });
    }
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
            ...rest
          }: RouteConfig &
            RouteDescription & {
              descriptor: PropertyDescriptor;
              propertyKey: string | Symbol;
            }) => {
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
            routeEvent.emit("update_route", {
              path,
              method,
              ...rest,
            });
            app[method]("/api" + path, handler);
          }
        );
      }
    }
  };
}

export type RouteDescription = {
  request_payload?: object;
  response_payload?: object;
  usage?: string;
  isAuth?: string;
};
export const routeDescription = (description: RouteDescription) => {
  return (
    target: any,
    propertyKey: string | symbol,
    __: PropertyDescriptor
  ) => {
    target[RouteSymbol] = target[RouteSymbol] || new Map();
    if (target[RouteSymbol].get(propertyKey)) {
      target[RouteSymbol].set(propertyKey, {
        ...target[RouteSymbol].get(propertyKey),
        ...description,
      });
    } else {
      target[RouteSymbol].set(propertyKey, {
        ...description,
      });
    }
  };
};
