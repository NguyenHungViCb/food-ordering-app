import User from "../../models/user";
import {
  attributeToPlainObj,
  getSchemaInPlainObj,
} from "../../utils/modelUtils";

export class UserModel {
  constructor(
    public first_name: string,
    public last_name: string,
    public email: string
  ) {}
}

export class UserCreation extends UserModel {
  constructor(
    public id: number,
    public first_name: string,
    public last_name: string,
    public email: string,
    public email_verified: boolean,
    public phone_number: string,
    public password: string,
    public refresh_token: string,
    public facebook_id: string,
    public google_id: string,
    public avatar: string,
    public active: boolean,
    public birthday: Date
  ) {
    super(first_name, last_name, email);
  }
}

const {
  first_name,
  last_name,
  email,
  password,
  email_verified,
  phone_number,
  avatar,
  active,
} = User.getAttributes();
export const localRequestPayload = {
  ...getSchemaInPlainObj({
    first_name,
    last_name,
    email,
  }),
  ...attributeToPlainObj(password, true),
};

export const userCreationResponsePayload = getSchemaInPlainObj({
  first_name,
  last_name,
  email,
  email_verified,
  phone_number,
  avatar,
  active,
});
