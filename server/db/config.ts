import { Sequelize } from "sequelize";
import { DB_NAME, LOGGING, MODE, POST_URI } from "../utils/AppConfig";
import { green, red, bold } from "colors";

const modelConfig = (tableName: string) => {
  return {
    tableName: tableName,
    underscored: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  };
};

const sequelize = new Sequelize(POST_URI, {
  define: { underscored: true },
  logging: LOGGING,
  ...(MODE === "production"
    ? {
        dialectOptions: {
          ssl: {
            require: true,
            rejectUnauthorized: false,
          },
        },
      }
    : {}),
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

export { sequelize, modelConfig };
export default connectDb;
