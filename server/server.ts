import express from "express";
import cors from "cors";
import connectDb from "./db/config";
import { EventEmitter } from "events";
import path from "path";

connectDb();

const app = express();
app.use(express.json());
app.use(
  cors({
    origin: ["http://localhost:3000"], // May be we don't need this
  })
);
app.engine(".html", require("ejs").__express);
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "html");

const routeEvent = new EventEmitter();
const routes: any[] = [];
routeEvent.on("update_route", (route: any) => {
  routes.push(route);
  app.get("/", (_, res) => {
    res.render("index", { routes });
  });
  app.get("/api", (_, res) => {
    res.json({ routes });
  });
});

export { routeEvent };
export default app;
