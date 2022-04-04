import { yellow } from "colors";
import app from "./express";
import { PORT } from "./utils/AppConfig";
import ProductController from "./controllers/product";
import CategoryController from "./controllers/category";

app.listen(PORT, () => {
  console.log(yellow.bold(`App listening on port ${PORT}`));
  new ProductController();
  new CategoryController();
});
