import { NextFunction, Request, Response } from "express";
import Stripe from "stripe";
import { jwtValidate } from "../../middlewares/auths";
import { controller, routeConfig } from "../../utils/routeConfig";
import { queryToNum } from "../../utils/validations/assertions";

@controller
class OrderController {
  static path = "/orders";

  extractIntent(req: Request) {
    let payment_intent: Stripe.Response<Stripe.PaymentIntent>;
    if (req.query.intent && typeof req.query.intent === "string") {
      payment_intent = JSON.parse(req.query.intent);
    } else {
      throw new Error("Payment did not complete");
    }
    return payment_intent;
  }

  @routeConfig({
    method: "get",
    path: `${OrderController.path}/complete`,
    middlewares: [jwtValidate],
  })
  async placeOrder(req: Request, res: Response, __: NextFunction) {
    /* We will add create order later */
    const queries = req.query;
    console.log(queries);
    // if (method === "stripe") {
    //   console.log(this.extractIntent(req).client_secret)

    //   return res.json({
    //     data: {
    //       payment_intent: this.extractIntent(req).client_secret,
    //       total: queryToNum(total),
    //     },
    //     success: true,
    //   });
    // } else if (method === "paypal") {
    //   return res.json({
    //     data: {
    //       client_secret: req.query.client_secret,
    //       total: queryToNum(total),
    //     },
    //   });
    // }
    return res.json({ success: true });
  }
}

export default OrderController;
