import { Sequelize } from "sequelize";
import { DB_NAME, LOGGING, POST_URI } from "../utils/AppConfig";
import { green, red, bold } from "colors";

const sequelize = new Sequelize(POST_URI, {
  define: { underscored: true },
  logging: LOGGING,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
});
const connectDb = async () => {
  try {
    await sequelize.authenticate();
    console.log(
      green(`successfully connect to database ${bold.underline(DB_NAME)}`)
    );
  } catch (error) {
    console.log(
      red(`Unable to connect to the database ${bold.underline(DB_NAME)}\n`),
      error
    );
  }
};

export { sequelize };
export default connectDb;
