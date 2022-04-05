import { NextFunction, RequestHandler, Request, Response } from "express";
import app, { routeEvent } from "../express";
import { BasicResponse } from "../types/commonInterfaces";
import { Model, ModelAttributeColumnOptions } from "sequelize";

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
            ): Promise<Response<BasicResponse<any>>> => {
              try {
                return await descriptor.value.apply(this, [req, res, next]);
              } catch (error: any) {
                return res.json({ message: error.message, success: false });
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

const dbTypeToString = (type: string) => {
  const lowerCaseType = type.toLowerCase();
  if (
    lowerCaseType.includes("int") ||
    lowerCaseType.toLowerCase().includes("decimal")
  ) {
    return "number";
  } else if (lowerCaseType.includes("varchar")) {
    return "string";
  } else if (lowerCaseType.includes("time")) {
    return "Date";
  }
  return "unknown";
};

export const getSchemaInPlainObj = (attributes: {
  [attribute: string]: ModelAttributeColumnOptions<Model<any, any>>;
}) => {
  let obj: { [key: string]: string } = {};
  Object.entries(attributes).map(([key, value]) => {
    obj = { ...obj, [key]: dbTypeToString(value.type.toString({})) };
  });
  return obj;
};
