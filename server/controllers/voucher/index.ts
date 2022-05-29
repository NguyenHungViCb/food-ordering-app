import { NextFunction, Request, Response } from "express";
import { sequelize } from "../../db/config";
import { getOrderTotal } from "../../middlewares/payment";
import Voucher from "../../models/voucher";
import { getAttributes, getAttributesData } from "../../utils/modelUtils";
import {
  controller,
  routeConfig,
  routeDescription,
} from "../../utils/routeConfig";
import { isNotNull, queryToNum } from "../../utils/validations/assertions";
import { requireValues } from "../../utils/validations/modelValidation";
import { activeCartValidate } from "../../middlewares/carts";
import { Op } from "sequelize";
import { jwtValidate } from "../../middlewares/auths";

const path = "/vouchers";
@controller
class VoucherController {
  @routeDescription({
    request_payload: getAttributes(Voucher, [
      "code",
      "description",
      "valid_from",
      "valid_until",
      "discount",
      "min_value",
    ]),
    response_payload: getAttributes(Voucher),
    isAuth: true,
    usage: "Create a single voucher"
  })
  @routeConfig({ method: "post", path: `${path}/create/single` })
  async createVoucher(req: Request, res: Response, __: NextFunction) {
    const { code, description, valid_from, valid_until, discount, min_value } =
      req.body;
    requireValues({
      code,
      description,
      valid_from,
      valid_until,
      discount,
      min_value,
    });
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
          "min_value",
          "discount",
          "valid_from",
          "valid_until",
        ]),
      },
    });
  }

  // @routeConfig({ method: "get", path: `${path}/products` })
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

  @routeDescription({
    response_payload: getAttributes(Voucher),
    isAuth: true,
    usage: "Get applicabled vouchers for current cart",
  })
  @routeConfig({
    method: "get",
    path: `${path}/applicabled/cart`,
    middlewares: [jwtValidate, activeCartValidate, getOrderTotal],
  })
  async getApplicabledVoucher(req: Request, res: Response, __: NextFunction) {
    const { total } = req.body;
    const applicabledVouchers = await Voucher.findAll({
      where: { min_value: { [Op.lte]: total } },
    });
    return res.json({ data: applicabledVouchers, success: true });
  }
}

export default VoucherController;
