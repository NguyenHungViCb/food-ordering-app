import { ORDER_STATUS } from "../../types/order";

export const orderStatesTransitionRules = {
  [ORDER_STATUS.pending]: [ORDER_STATUS.confirmed, ORDER_STATUS.canceled],
  [ORDER_STATUS.confirmed]: [ORDER_STATUS.processing],
  [ORDER_STATUS.processing]: [ORDER_STATUS.shipping],
  [ORDER_STATUS.shipping]: [ORDER_STATUS.succeeded, ORDER_STATUS.canceled],
  [ORDER_STATUS.canceled]: [],
  [ORDER_STATUS.succeeded]: [],
};

export const isAllowTransitionState = (current: string, target: string) => {
  const orderStates = Object.values(ORDER_STATUS);
  if (
    !orderStates.includes(current as ORDER_STATUS) ||
    !orderStates.includes(target as ORDER_STATUS)
  ) {
    throw new Error(JSON.stringify({ code: 422, message: "Invalid state" }));
  }
  const targets: ORDER_STATUS[] =
    orderStatesTransitionRules[current as ORDER_STATUS];
  if (targets.includes(target as ORDER_STATUS)) {
    return true;
  }
  return false;
};
