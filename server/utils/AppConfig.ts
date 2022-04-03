import dotenv from "dotenv";
dotenv.config();

export const DB_NAME = process.env.DB_NAME || "";
export const DB_USERNAME = process.env.DB_USERNAME || "";
export const DB_HOST = process.env.DB_HOST || "";
export const POST_URI = `postgres://${DB_USERNAME}@${DB_HOST}:5432/${DB_NAME}`;
export const PORT = process.env.PORT;
