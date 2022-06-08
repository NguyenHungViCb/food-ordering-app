import { useLocation } from "react-router-dom";

const Drawer = () => {
  const location = useLocation();
  return (
    <div>
      <div className="drawer-side">
        <label htmlFor="my-drawer" className="drawer-overlay"></label>
        <ul className="menu p-4 overflow-y-auto w-80 bg-base-100 text-base-content">
          <li>
            <a  className={location.pathname.includes("/orders") ? "active" : ""}>Orders</a>
          </li>
          <li>
            <a>Accounts</a>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default Drawer;
