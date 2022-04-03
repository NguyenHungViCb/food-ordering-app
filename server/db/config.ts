import { Sequelize } from "sequelize";
import { DB_NAME, POST_URI } from "../utils/AppConfig";
import { green, red, bold } from "colors";

const sequelize = new Sequelize(POST_URI);
const connectDb = async () => {
  try {
    await sequelize.authenticate();
    console.log(
      green(`successfully connect to database ${bold.underline(DB_NAME)}`)
    );
  } catch (error) {
    console.log(red("Unable to connect to the database\n"), error);
  }
};

export { sequelize };
export default connectDb;
