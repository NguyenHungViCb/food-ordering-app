import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { ImageCreation, ImageModel } from "../../types/image";

const Image = sequelize.define<
  Model<ImageCreation, ImageModel | ImageCreation>
>(
  "Image",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    src: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING,
    },
    ratio: {
      type: DataTypes.ENUM("landscape", "portrait"),
    },
  },
  modelConfig("images")
);

// Image.sync({ force: true });

export default Image;
