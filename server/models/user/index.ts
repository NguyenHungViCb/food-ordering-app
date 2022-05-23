import { DataTypes, Model } from "sequelize";
import { modelConfig, sequelize } from "../../db/config";
import { UserCreation, UserModel } from "../../types/user/userInterfaces";

const User = sequelize.define<Model<UserCreation, UserModel | UserCreation>>(
  "User",
  {
    id: {
      type: DataTypes.BIGINT,
      autoIncrement: true,
      allowNull: false,
      primaryKey: true,
    },
    first_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    last_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    birthday: {
      type: DataTypes.DATE,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isEmail: true,
      },
      unique: true,
    },
    email_verified: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
    phone_number: {
      type: DataTypes.STRING,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      validate: {
        min: 12,
      },
    },
    refresh_token: {
      type: DataTypes.STRING,
    },
    facebook_id: {
      type: DataTypes.STRING,
      unique: true,
    },
    google_id: {
      type: DataTypes.STRING,
      unique: true,
    },
    avatar: {
      type: DataTypes.TEXT,
      defaultValue:
        "https://scontent.fsgn5-3.fna.fbcdn.net/v/t1.30497-1/cp0/c15.0.50.50a/p50x50/84628273_176159830277856_972693363922829312_n.jpg?_nc_cat=1&ccb=1-5&_nc_sid=12b3be&_nc_ohc=XyWt8Z2JeBcAX894iLG&_nc_ht=scontent.fsgn5-3.fna&edm=AP4hL3IEAAAA&oh=15811581152ebb890135bfd3201e3439&oe=61D27B38",
      allowNull: false,
    },
    active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    stripe_id: {
      type: DataTypes.STRING,
    },
    selected_card: {
      type: DataTypes.STRING,
    },
  },
  modelConfig("users")
);

export default User;
