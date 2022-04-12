export function isNotNull<T>(
  value: T,
  name = "value"
): asserts value is NonNullable<T> {
  if (value === null || value == undefined) {
    throw new Error(name + " should not be null");
  }
}

export function isArray<T>(value: any, name = "value"): asserts value is T {
  isNotNull(value);
  if (!Array.isArray(value)) {
    throw new Error(name + " should be any array");
  }
}
