import jwt from "jsonwebtoken";
import {
  JWT_EXPIRY,
  JWT_REFRESH_EXPIRY,
  JWT_SECRET,
  REFRESH_TOKEN_SECRET,
} from "./AppConfig";

const generateToken = (payload: Object) => {
  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: JWT_EXPIRY,
  });
};

const generateRefreshToken = (payload: Object): string => {
  return jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: JWT_REFRESH_EXPIRY,
  });
};

export { generateRefreshToken, generateToken };
