import { red } from "colors";
import {
  CreateOptions,
  Attributes,
  Model,
  CreationAttributes,
  ModelCtor,
  Transaction,
} from "sequelize";
import { sequelize } from "../db/config";

export async function createWithTransaction<
  M extends Model,
  O extends CreateOptions<Attributes<M>> = CreateOptions<Attributes<M>>
>(
  entity: ModelCtor<M>,
  query: {
    values?: CreationAttributes<M>;
    option?: O;
  },
  callback: (entity: M, transaction: Transaction) => any
) {
  // Start transaction
  const t = await sequelize.transaction();
  const newTransaction = await sequelize.transaction();
  try {
    const createdEntity = await entity.create(query.values, {
      ...query.option,
      transaction: t,
    });
    await t.commit();

    try {
      const callbackValues = await callback(createdEntity, newTransaction);
      await newTransaction.commit();
      return { createdEntity, callbackValues };
    } catch (error) {
      await createdEntity.destroy();
      console.log(error);
    }
    return {
      createdEntity,
      callbackValues: null,
      error: "Error occur while create product",
    };
  } catch (error: any) {
    // Rollback transaction if error occur
    console.log(red(error));
    await t.rollback();
    await newTransaction.rollback();
    throw new Error("Cannot create " + entity.name.toLowerCase());
  }
}
