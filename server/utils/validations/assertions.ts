export function isNotNull<T>(
  value: T,
  name = "value",
  message = "should not be null"
): asserts value is NonNullable<T> {
  if (value === null || value == undefined) {
    throw new Error(name + " " + message);
  }
}

export function isArray<T>(
  value: any,
  name = "value"
): asserts value is Array<T> {
  isNotNull(value);
  if (!Array.isArray(value)) {
    throw new Error(name + " should be any array");
  }
}

export function queryToNum(value: any) {
  console.log({ value }, typeof value);
  if (typeof value !== "string" && typeof value !== "number") {
    throw new Error("Invalid data format");
  }
  if (typeof value === "string") {
    const num = parseInt(value);
    return num;
  }
  return value;
}
