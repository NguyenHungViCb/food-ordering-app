import { useNavigate } from "react-router-dom";
import { orderColors } from "../utils/orders";

const OrderTable: React.FC<{ orders: any[] }> = ({ orders }) => {
  const navigate = useNavigate();
  if (!orders || orders.length === 0) {
    return <div>No order found</div>;
  }

  headers.products.shorten(orders[0].details, 3);
  return (
    <div className="overflow-x-auto w-full">
      <table className="table w-full">
        <OrderTableHead />
        <tbody>
          {orders.map((order) => (
            <tr key={order.id}>
              <th>
                <label>
                  <input type="checkbox" className="checkbox" />
                </label>
              </th>
              <td>{order.id}</td>
              <td>{headers.products.shorten(order.details, 3)}</td>
              <td>${order.total}</td>
              <th>
                <div
                  className={`btn btn-ghost btn-xs ${
                    orderColors[order.status as keyof typeof orderColors]
                  }`}
                >
                  {order.status}
                </div>
              </th>
              <th>
                <button
                  className="btn"
                  onClick={() => navigate(`/orders/detail/${order.id}`)}
                >
                  View
                </button>
              </th>
            </tr>
          ))}
        </tbody>
        <OrderTableFoot />
      </table>
    </div>
  );
};

const headers = {
  id: { name: "id" },
  products: {
    name: "products",
    shorten: (details: any[], limit: number) => {
      return details.reduce(
        (prev, curr, index) =>
          prev +
          (curr.product?.name || "") +
          (index === details.length - 1 ? "" : index < limit ? ";" : "..."),
        ""
      );
    },
  },
  total: { name: "total" },
  status: { name: "status" },
  user: { name: "" },
};

const OrderTableHead = () => {
  return (
    <thead>
      <tr>
        <th>
          <label>
            <input type="checkbox" className="checkbox" />
          </label>
        </th>
        {Object.values(headers).map((header, index) => (
          <th key={index}>
            <label>{header.name}</label>
          </th>
        ))}
      </tr>
    </thead>
  );
};

const OrderTableFoot = () => {
  const footers = [
    { name: "id" },
    { name: "product" },
    { name: "total" },
    { name: "status" },
    { name: "" },
  ];
  return (
    <tfoot>
      <tr>
        <th></th>
        {footers.map((header, index) => (
          <th key={index}>
            <label>{header.name}</label>
          </th>
        ))}
      </tr>
    </tfoot>
  );
};

export default OrderTable;
