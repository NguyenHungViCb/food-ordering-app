const ProductsTable: React.FC<{ details: any[] }> = ({ details }) => {
  console.log({ details });
  return (
    <div className="overflow-x-auto w-full mt-8">
      <table className="table w-full">
        <thead>
          <tr>
            <th>#</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          {details.map((detail, index) => (
            <tr key={index}>
              <th>{index + 1}</th>
              <td>
                <div className="flex items-center space-x-3">
                  <div className="avatar">
                    <div className="mask mask-squircle w-12 h-12">
                      <img
                        src={detail.product.images[0].src}
                        alt="Avatar Tailwind CSS Component"
                      />
                    </div>
                  </div>
                  <div>
                    <div className="font-bold">{detail.product.name}</div>
                    <div className="text-sm opacity-50">
                      ${detail.product.price}
                    </div>
                  </div>
                </div>
              </td>
              <td>{detail.quantity} </td>
              <td>${detail.total}</td>
            </tr>
          ))}
        </tbody>
        <tfoot>
          <tr>
            <th>#</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Total</th>
          </tr>
        </tfoot>
      </table>
    </div>
  );
};

export default ProductsTable;
