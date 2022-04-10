import { getSchemaInPlainObj } from "../../utils/modelUtils";
import Image from "../../models/image";

const { src, type, ratio, ...rest } = Image.getAttributes();
export const imagePlainObj = {
  ...getSchemaInPlainObj({ src }),
  ...getSchemaInPlainObj({ type, ratio }, true),
};
