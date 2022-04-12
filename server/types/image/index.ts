import { getAttributes } from "../../utils/modelUtils";
import Image from "../../models/image";

class ImageModel {
  constructor(public src: string, public type: string, public ratio: string) {}
}

class ImageCreation extends ImageModel {
  constructor(
    public id: number,
    public src: string,
    public type: string,
    public ratio: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(src, type, ratio);
  }
}

export const imagePlainObj = {
  ...getAttributes(Image, ["src"]),
  ...getAttributes(Image, ["type", "ratio"]),
};

export { ImageModel, ImageCreation };
