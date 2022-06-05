export const errorsConverter = {
  jsonOrString(error: any): string | any {
    let err;
    try {
      err = JSON.parse(error.message);
    } catch (_) {
      err = error.message;
    }
    return err;
  },
};
