import dotenv from "dotenv";
dotenv.config();

export const DB_NAME = process.env.DB_NAME || "";
export const DB_USERNAME = process.env.DB_USERNAME || "";
export const DB_PASSWORD = process.env.DB_PASSWORD;
export const DB_HOST = process.env.DB_HOST || "";
export const POST_URI = `postgres://${DB_USERNAME}${
  DB_PASSWORD ? ":" + DB_PASSWORD : ""
}@${DB_HOST}:5432/${DB_NAME}`;
export const PORT = process.env.PORT;
export const LOGGING = process.env.LOGGING === "true";
export const JWT_SECRET = process.env.JWT_CECRET || "";
export const JWT_EXPIRY = eval(process.env.SESSION_EXPIRY!) || 60 * 15;
export const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET || "";
export const JWT_REFRESH_EXPIRY =
  eval(process.env.REFRESH_TOKEN_EXPIRY!) || 60 * 60 * 24 * 30;
export const MODE = process.env.MODE || "development";
