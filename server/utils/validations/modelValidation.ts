function validate<T>(value: T, name?: string) {
  const helper = {
    value: value,
    name: name,
    isPostive: function () {
      if (typeof this.value === "number" && this.value < 0) {
        throw new Error((this.name || "value") + " must greater than 0");
      }
      return this;
    },
    isTruthy: function () {
      if (this.value === null || this.value === undefined) {
        throw new Error((this.name || "value") + " must not be empty");
      }
      return this;
    },
    isNumber: function () {
      // @ts-ignore
      if (isNaN(this.value)) {
        throw new Error((this.name || "value") + " must be a number");
      }
      return this;
    },
    isArray: function () {
      if (!Array.isArray(this.value)) {
        throw new Error((this.name || "value") + " must be an array");
      }
      return this;
    },
  };
  return helper;
}

export const requireValues = (object: Object) => {
  Object.entries(object).forEach(([key, value]) => {
    validate(value, key).isTruthy();
  });
};

export default validate;
