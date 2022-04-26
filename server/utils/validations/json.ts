function parseToJSON(value: string) {
  try {
    return JSON.parse(value);
  } catch (error) {
    return value;
  }
}

export { parseToJSON };
