import User from "../../models/user";
import { getAttributes } from "../../utils/modelUtils";

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
    public birthday: Date,
    public stripe_id: string,
    public selected_card: string,
    public address: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(first_name, last_name, email);
  }
}

export const localRequestPayload = {
  ...getAttributes(User, ["first_name", "last_name", "email"]),
  ...getAttributes(User, [{ attribute: "password", optional: true }]),
};

export const userCreationResponsePayload = getAttributes(User, [
  "first_name",
  "last_name",
  "email",
  "email_verified",
  "phone_number",
  "birthday",
  "avatar",
  "active",
  "created_at",
  "updated_at",
  "address",
]);
