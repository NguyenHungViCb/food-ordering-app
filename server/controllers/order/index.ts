import { NextFunction, Request, Response } from "express";
import Stripe from "stripe";
import { jwtValidate } from "../../middlewares/auths";
import { controller, routeConfig } from "../../utils/routeConfig";

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
    const {} = req.query;
    return res.json({ success: true });
  }
}

export default OrderController;
