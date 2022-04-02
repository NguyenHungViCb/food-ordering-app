import { yellow } from "colors";
import app from "./server";
import { PORT } from "./utils/AppConfig";
import ProductController from "./controllers/productController";

app.listen(PORT, () => {
  console.log(yellow.bold(`App listening on port ${PORT}`));
  new ProductController();
});
