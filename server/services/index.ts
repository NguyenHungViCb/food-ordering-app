import { red } from "colors";
import {
  CreateOptions,
  Attributes,
  Model,
  CreationAttributes,
  ModelCtor,
  Transaction,
  WhereOptions,
} from "sequelize";
import { sequelize } from "../db/config";
import { Sequelize } from "../models";

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

export async function upsert<M extends Model, TAttributes = Attributes<M>>(
  model: ModelCtor<M>,
  option: {
    condition: WhereOptions<TAttributes>;
    value?: CreationAttributes<M>;
    transaction?: Transaction;
  }
): Promise<[result: M, created: boolean]> {
  return await model
    .findOne({ where: option.condition, transaction: option.transaction })
    .then(async (response) => {
      if (response) {
        const result = await response.update(option.value || option.condition, {
          transaction: option.transaction,
        });
        return [result, false];
      } else {
        const result = await model.create(
          option.value || (option.condition as CreationAttributes<M>),
          { transaction: option.transaction }
        );
        return [result, true];
      }
    });
}

export async function updateIfExist<
  M extends Model,
  K extends keyof TAttributes | "created_at" | "updated_at",
  TAttributes = Attributes<M>
>(model: M, updateValues: { [key in K]: Attributes<M>[key] }) {
  const filtered = Object.entries(updateValues).filter(([_, value]) => {
    return value !== undefined && value !== true;
  });
  return await model.update(Object.fromEntries(filtered));
}
