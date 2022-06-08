import axios from "axios";
import { BASE_URL } from "./AppConfig";

const axiosInstance = axios.create({
  withCredentials: true,
  headers: {
    Authorization:
      "Bearer " +
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjU0NjY2MDIyLCJleHAiOjE2NTQ3NTI0MjJ9.OpeYz22SNshH6xooUPANYXcGkNrodXGYqGV2b6hBbxw",
  },
});

const fetchAllOrders = async () => {
  const orders = await axiosInstance.get(BASE_URL + "/orders/all");
  return orders;
};

const fetchOrderById = async (id: string) => {
  const order = await axiosInstance.get(BASE_URL + `/orders/${id}`);
  return order;
};

const updateStatus = async (target: string) => {
  const order = await axiosInstance.put(BASE_URL + "/orders/status/update", {
    status: target,
  });
  return order;
};

const orderColors = {
  pending: "text-neutral-content",
  canceled: "text-error",
  succeeded: "text-success",
  confirmed: "text-info",
  processing: "text-info",
  shipping: "text-info",
};

export const orderStatesTransitionRules: { [key: string]: string[] } = {
  pending: ["confirmed", "canceled"],
  confirmed: ["processing"],
  processing: ["shipping"],
  shipping: ["succeeded"],
  canceled: [],
  succeeded: [],
};

export const stateMappingAction: {
  [key in keyof typeof orderStatesTransitionRules]: string;
} = {
  pending: "",
  confirmed: "Confirm",
  processing: "Process",
  shipping: "Ship",
  canceled: "cancel",
  succeeded: "complete",
};

export const getTransitionabledStates = (current: string) => {
  return orderStatesTransitionRules[current];
};

export { fetchAllOrders, fetchOrderById, orderColors, updateStatus };
