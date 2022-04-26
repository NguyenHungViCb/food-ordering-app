export function isNotNull<T>(
  value: T,
  name = "value",
  message = "should not be null"
): asserts value is NonNullable<T> {
  if (value === null || value == undefined) {
    throw new Error(name + " " + message);
  }
}

export function isArray<T>(value: any, name = "value"): asserts value is T {
  isNotNull(value);
  if (!Array.isArray(value)) {
    throw new Error(name + " should be any array");
  }
}