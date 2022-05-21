import {
  Attributes,
  Model,
  ModelAttributeColumnOptions,
  ModelCtor,
} from "sequelize";

const dbTypeToString = (type: string) => {
  const lowerCaseType = type.toLowerCase();
  if (
    lowerCaseType.includes("int") ||
    lowerCaseType.toLowerCase().includes("decimal")
  ) {
    return "number";
  } else if (
    lowerCaseType.includes("varchar") ||
    lowerCaseType.includes("text")
  ) {
    return "string";
  } else if (lowerCaseType.includes("time")) {
    return "Date";
  } else if (lowerCaseType.includes("bool")) {
    return "boolean";
  }
  return "unknown";
};

export const getSchemaInPlainObj = (
  attributes: {
    [attribute: string]: ModelAttributeColumnOptions<Model<any, any>>;
  },
  optional?: boolean
) => {
  let obj: { [key: string]: string } = {};
  Object.entries(attributes).map(([key, value]) => {
    if (optional) {
      obj = { ...obj, [key + "?"]: dbTypeToString(value.type.toString({})) };
    } else {
      obj = { ...obj, [key]: dbTypeToString(value.type.toString({})) };
    }
  });
  return obj;
};

export const attributeToPlainObj = (
  attribute: ModelAttributeColumnOptions<Model<any, any>>,
  optional?: boolean
) => {
  if (optional) {
    return {
      [(attribute.field || "undefined") + "?"]: dbTypeToString(
        attribute.type.toString({})
      ),
    };
  } else {
    return {
      [attribute.field || "undefined"]: dbTypeToString(
        attribute.type.toString({})
      ),
    };
  }
};

export const createPayload = (...args: object[]) => {
  let obj: { [key: string]: string } = {};
  args.forEach((arg) => {
    obj = { ...obj, ...arg };
  });
  return obj;
};

type keyvalue<K> = {
  attribute: K;
  optional?: boolean;
};

export function getAttributes<
  M extends Model,
  K extends keyof TAttributes | "created_at" | "updated_at",
  TAttributes = Attributes<M>
>(model: ModelCtor<M>, keys?: (keyvalue<K> | K)[]) {
  const attributes = model.getAttributes();
  if (keys && keys.length > 0) {
    let obj: { [key: string]: string } = {};
    for (const item of keys) {
      for (const [key, value] of Object.entries(attributes)) {
        // @ts-ignore
        if (item.attribute && item.attribute === key) {
          // @ts-ignore
          if (item.optional) {
            obj = {
              ...obj,
              [key + "?"]: dbTypeToString(value.type.toString({})),
            };
          } else {
            obj = { ...obj, [key]: dbTypeToString(value.type.toString({})) };
          }
          break;
        } else if (item === key) {
          if (value.allowNull === false) {
            obj = { ...obj, [key]: dbTypeToString(value.type.toString({})) };
          } else {
            obj = {
              ...obj,
              [key + "?"]: dbTypeToString(value.type.toString({})),
            };
          }
          break;
        }
      }
    }
    return obj;
  }
  return getSchemaInPlainObj(attributes);
}

export function getAttributesData<
  M extends Model,
  K extends keyof TAttributes | "created_at" | "updated_at",
  TAttributes = Attributes<M>
>(model: M, keys: K[]) {
  // @ts-ignore
  let obj: { [key in K]: Model } = {};
  for (const key of keys) {
    Object.assign(obj, { [key]: model.get(key as string) });
  }
  return obj;
}

export function imageToArray<M extends Model>(data: M) {
  return {
    ...data?.get(),
    images: (data?.getDataValue("images") as string)
      .split(";")
      .map((url) => ({
        src: url,
      }))
      .filter((item) => item.src.trim() !== ""),
  };
}
