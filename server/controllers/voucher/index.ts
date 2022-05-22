import { NextFunction, Request, Response } from "express";
import { sequelize } from "../../db/config";
import Voucher from "../../models/voucher";
import { getAttributesData } from "../../utils/modelUtils";
import { controller, routeConfig } from "../../utils/routeConfig";
import {
  isArray,
  isNotNull,
  queryToNum,
} from "../../utils/validations/assertions";
import { requireValues } from "../../utils/validations/modelValidation";

const path = "/vouchers";
@controller
class VoucherController {
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createVoucher(req: Request, res: Response, __: NextFunction) {
    const {
      code,
      description,
      valid_from,
      valid_until,
      products,
      discount,
      min_value,
    } = req.body;
    requireValues({
      code,
      description,
      valid_from,
      valid_until,
      products,
      discount,
    });
    isArray<Array<number>>(products);
    const transaction = await sequelize.transaction();
    const voucher = await Voucher.create(
      {
        code,
        description,
        valid_from,
        valid_until,
        discount,
        min_value,
      },
      { transaction }
    );
    await transaction.commit();
    return res.json({
      data: {
        ...getAttributesData(voucher, [
          "id",
          "code",
          "description",
          "valid_from",
          "valid_until",
        ]),
      },
    });
  }

  @routeConfig({ method: "get", path: `${path}/products` })
  async getVouchersByProduct(req: Request, res: Response, __: NextFunction) {
    const { id } = req.query;
    isNotNull(id, "id");
    const convertedId = queryToNum(id);
    const all = await Voucher.findAll({
      where: {
        "$details.product_id$": convertedId,
      },
    });
    return res.json({ data: all, success: true });
  }
}

export default VoucherController;