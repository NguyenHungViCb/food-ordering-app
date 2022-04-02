import dotenv from "dotenv";
import { EventEmitter } from "events";
dotenv.config();

export const DB_NAME = process.env.DB_NAME || "";
export const DB_USERNAME = process.env.DB_USERNAME || "";
export const DB_HOST = process.env.DB_HOST || "";
export const POST_URI = `postgres://${DB_USERNAME}@${DB_HOST}:5432/${DB_NAME}`;
export const PORT = process.env.PORT;

// I might change this to listen to a special case
type RouteInfo = { path: string; method: string; auth: boolean };
export const routes: RouteInfo[] = [];

function updateRoutes(route: RouteInfo) {
  routes.push(route);
}

const routeEvent = new EventEmitter();
routeEvent.on("update_route", (route: RouteInfo) => {
  updateRoutes(route);
});

export const AppRoute = {
  update: (route: RouteInfo) => {
    routeEvent.emit("update_route", route);
  },
};
