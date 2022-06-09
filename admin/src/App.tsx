import { useEffect, useState } from "react";
import "./App.css";
import Drawer from "./components/Drawer";
import Navbar from "./components/Navbar";
import OrderTable from "./components/OrderTable";
import { fetchAllOrders } from "./utils/orders";
import { Route, Routes } from "react-router-dom";
import Detail from "./components/Detail";

function App() {
  const [orders, setOrders] = useState<any[]>([]);
  useEffect(() => {
    fetchAllOrders().then((data: any) => {
      const { rows } = data.data.data;
      setOrders(rows);
    });
  }, []);
  return (
    <div className="App">
      <Navbar />
      <main className="flex py-5">
        <Drawer />
        <div className="content-container w-full p-4">
          <Routes>
            <Route
              path="/orders"
              element={
                <OrderTable
                  orders={orders.sort(
                    (a, b) =>
                      new Date(b.created_at).getTime() -
                      new Date(a.created_at).getTime()
                  )}
                />
              }
            />
            <Route path="/orders/detail/:id" element={<Detail />} />
          </Routes>
        </div>
      </main>
    </div>
  );
}

export default App;
