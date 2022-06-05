import { yellow } from "colors";
import app from "./express";
import { PORT } from "./utils/AppConfig";
import ProductController from "./controllers/product";
import CategoryController from "./controllers/category";
import UserController from "./controllers/user";
import CartController from "./controllers/cart";
import VoucherController from "./controllers/voucher";
import PaymentController from "./controllers/payment";
import OrderController from "./controllers/order";
import http from "http";
import RootSocket from "./controllers/socket";

const server = http.createServer(app);
RootSocket.initialize(server);
server.listen(PORT, () => {
  console.log(yellow.bold(`App listening on port ${PORT}`));
  new ProductController();
  new CategoryController();
  new UserController();
  new CartController();
  new VoucherController();
  new PaymentController();
  new OrderController();
});
