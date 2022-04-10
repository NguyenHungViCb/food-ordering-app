import { getSchemaInPlainObj } from "../../utils/modelUtils";
import Image from "../../models/image";

class ImageModel {
  constructor(public src: string, public type: string, public ratio: string) {}
}

class ImageCreation extends ImageModel {
  constructor(
    public id: number,
    public src: string,
    public type: string,
    public ratio: string
  ) {
    super(src, type, ratio);
  }
}

const { src, type, ratio } = Image.getAttributes();
export const imagePlainObj = {
  ...getSchemaInPlainObj({ src }),
  ...getSchemaInPlainObj({ type, ratio }, true),
};

export { ImageModel, ImageCreation };
