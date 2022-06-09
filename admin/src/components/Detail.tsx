import { useEffect, useState } from "react";
import { useParams } from "react-router";
import {
  fetchOrderById,
  getTransitionabledStates,
  orderColors,
  stateMappingAction,
  updateStatus,
} from "../utils/orders";
import MasterCard from "./MasterCard";
import ProductsTable from "./ProductsTable";
import Timeline from "./Timeline";
import Visa from "./Visa";

const getOriginalTotal = (details: any[]) => {
  let total = 0;
  for (const item of details) {
    total += parseInt(item.total);
  }
  return total;
};

const formatDate = (date: Date) => {
  return `${date.getFullYear()}/${date.getMonth()}/${date.getDate()}`;
};

const Detail = () => {
  const [order, setOrder] = useState<any>();
  const params = useParams();
  useEffect(() => {
    if (params.id) {
      fetchOrderById(params.id).then(({ data }) => {
        setOrder(data.data);
      });
    }
  }, []);

  if (!order) {
    return null;
  }
  console.log(order.status_history);

  return (
    <>
      <div className="flex justify-between gap-8">
        <div className="w-full flex flex-col gap-8">
          <div className="card w-full bg-base-100 shadow-xl border border-slate-800">
            <div className="card-body">
              <h2 className="card-title">Payment Method</h2>
              <div className="flex items-center gap-5 text-sm">
                {order.payment_method === "mastercard" && <MasterCard />}
                {order.payment_method === "visa" && <Visa />}
                <span className="tracking-wider">
                  **** **** **** {order.payment_detail}
                </span>
              </div>
            </div>
          </div>
          <div className="card bg-base-100 shadow-xl border border-slate-800 w-full">
            <div className="card-body tracking-wider">
              <h2 className="card-title">
                Order{" "}
                <span
                  className={
                    orderColors[order.status as keyof typeof orderColors]
                  }
                >
                  ({order.status})
                </span>
              </h2>
              <div className="flex justify-start gap-[1ch] text-sm">
                Total:{" "}
                {order.voucher && (
                  <span className="line-through text-gray-500">
                    ${getOriginalTotal(order.details)}
                  </span>
                )}{" "}
                ${order.total}
              </div>
              {order.voucher && (
                <div className="flex justify-start text-sm">
                  Voucher: {order.voucher.code}
                </div>
              )}
              {order.created_at && (
                <div className="flex justify-start text-sm">
                  Created At: {formatDate(new Date(order.created_at))}
                </div>
              )}
              {order.paid_at && (
                <div className="flex justify-start text-sm">
                  Paid At: {formatDate(new Date(order.paid_at))}
                </div>
              )}
              {order.canceled_at && (
                <div className="flex justify-start text-sm">
                  Created At: {formatDate(new Date(order.canceled_at))}
                </div>
              )}
            </div>
          </div>
        </div>
        <div className="card w-full bg-base-100 shadow-xl border border-slate-800 py-3">
          <div className="card-body">
            {order?.status_history && order.status_history.length > 0 && (
              <Timeline
                data={order.status_history.map((history: any) => ({
                  date: new Date(history.split("-")[0]),
                  title: history.split("-")[1],
                }))}
              />
            )}
          </div>
          <div className="px-2 flex flex-col gap-3">
            {order.status &&
              order.status.length > 0 &&
              getTransitionabledStates(order.status).map((state) => (
                <button
                  key={state}
                  className={
                    "btn " + orderColors[state as keyof typeof orderColors]
                  }
                  onClick={() => {
                    updateStatus(state).then(({ data }: any) => {
                      fetchOrderById(data.data.id).then(({ data }) => {
                        setOrder(data.data);
                      });
                    });
                  }}
                >
                  {stateMappingAction[state]}
                </button>
              ))}
          </div>
        </div>
      </div>
      <ProductsTable details={order.details}/>
    </>
  );
};

export default Detail;
