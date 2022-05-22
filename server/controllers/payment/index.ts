import { NextFunction, Request, Response } from "express";
import { Stripe } from "stripe";
import { jwtValidate } from "../../middlewares/auths";
import { getOrderTotal, voucherApply } from "../../middlewares/payment";
import { PAYPAL_SECRET, stripe, STRIPE_SECRET } from "../../utils/AppConfig";
import { controller, routeConfig } from "../../utils/routeConfig";
import OrderController from "../order";

@controller
class PaymentController {
  static path = "/payments";

  @routeConfig({
    method: "post",
    path: `${PaymentController.path}/stripe/card/add`,
    middlewares: [jwtValidate],
  })
  async stripeCheckout(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { paymentMethodId } = req.body;
    let customerId: string = user.getDataValue("stripe_id");
    if (!customerId || customerId.trim() == "") {
      // Create customer for the first checkout
      const customer = await stripe.customers.create({
        email: user.getDataValue("email"),
        payment_method: paymentMethodId,
      });
      // Save customer id
      await user.update({
        stripe_id: customer.id,
        selected_card: paymentMethodId,
      });
      customerId = customer.id;
    } else {
      // Attach new payment method to customer
      const currentList = await stripe.customers.listPaymentMethods(
        customerId,
        { type: "card" }
      );
      const newPaymentMethod = await stripe.paymentMethods.retrieve(
        paymentMethodId
      );
      // Check if card already attach to customer
      const index = currentList.data.findIndex(
        (method) =>
          method.card?.fingerprint === newPaymentMethod.card?.fingerprint &&
          method.card?.exp_month === newPaymentMethod.card?.exp_month &&
          method.card?.exp_year === newPaymentMethod.card?.exp_year
      );
      // Attach and change selected card if card is new
      if (index === -1) {
        await stripe.paymentMethods.attach(paymentMethodId, {
          customer: customerId,
        });
        await user.update({ selected_card: paymentMethodId });
      } else {
        // Change selected card to exist card
        await user.update({ selected_card: currentList.data[index].id });
      }
    }
    return res.json({ success: true });
  }

  @routeConfig({
    method: "post",
    path: `${PaymentController.path}/stripe/confirm`,
    middlewares: [jwtValidate, getOrderTotal],
  })
  async stripeConfirmPayment(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { total, payment_method } = req.body;
    const paymentIntent = await stripe.paymentIntents.create({
      amount: total * 100,
      currency: "usd",
      customer: user.getDataValue("stripe_id"),
      off_session: true,
      confirm: true,
      payment_method: payment_method,
    });
    return res.json({ data: paymentIntent, success: true });
  }
  @routeConfig({
    method: "get",
    path: `${PaymentController.path}/cards/saved`,
    middlewares: [jwtValidate],
  })
  async getSavedCard(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const stripePaymentHandler = new Stripe(STRIPE_SECRET, {
      apiVersion: "2020-08-27",
    });
    // return empty if user haven't add any card before
    if (
      !user.getDataValue("stripe_id") ||
      user.getDataValue("stripe_id") == ""
    ) {
      return res.json({ data: [], success: true });
    }
    const response = await stripePaymentHandler.customers.listPaymentMethods(
      user.getDataValue("stripe_id"),
      {
        type: "card",
      }
    );
    return res.json({
      data: response.data.map((method) => ({
        id: method.id,
        card: {
          brand: method.card?.brand,
          exp_month: method.card?.exp_month,
          exp_year: method.card?.exp_year,
          last4: method.card?.last4,
        },
      })),
      success: true,
    });
  }

  @routeConfig({
    method: "get",
    path: `${PaymentController.path}/methods/default`,
    middlewares: [jwtValidate],
  })
  async getDefaultPayment(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    if (
      user.getDataValue("selected_card") !== "paypal" &&
      user.getDataValue("selected_card").trim() !== ""
    ) {
      const paymentMethods = await stripe.customers.listPaymentMethods(
        user.getDataValue("stripe_id"),
        { type: "card" }
      );
      if (paymentMethods.data.length < 0) {
        await user.update({ selected_card: "" });
        return res.json({ data: null, success: true });
      }
      const defaultMethod = paymentMethods.data.find(
        (method) => method.id === user.getDataValue("selected_card")
      );
      if (!defaultMethod) {
        await user.update({ selected_card: "" });
        return res.json({ data: null, success: true });
      }
      return res.json({
        data: {
          id: defaultMethod.id,
          card: {
            brand: defaultMethod.card?.brand,
            exp_month: defaultMethod.card?.exp_month,
            exp_year: defaultMethod.card?.exp_year,
            last4: defaultMethod.card?.last4,
          },
        },
        success: true,
      });

    }
  }

  @routeConfig({
    method: "put",
    path: `${PaymentController.path}/methods/default/update`,
    middlewares: [jwtValidate],
  })
  async updateDefaultMethod(req: Request, res: Response, __: NextFunction) {
    const { user } = req;
    const { payment_method_id } = req.body;
    const paymentMethods = await stripe.customers.listPaymentMethods(
      user.getDataValue("stripe_id"),
      { type: "card" }
    );
    const selected = paymentMethods.data.find(
      (method) => method.id === payment_method_id
    );
    if (!selected) {
      throw new Error("update method failed");
    }
    await user.update({ selected_card: payment_method_id });
    return res.json({
      data: {
        id: selected.id,
        card: {
          brand: selected.card?.brand,
          exp_month: selected.card?.exp_month,
          exp_year: selected.card?.exp_year,
          last4: selected.card?.last4,
        },
      },
      success: true,
    });
  }

  @routeConfig({
    method: "post",
    path: `${PaymentController.path}/paypal`,
    middlewares: [jwtValidate, getOrderTotal, voucherApply],
  })
  async paypalCheckout(req: Request, res: Response, __: NextFunction) {
    const { total } = req.body;
    return res.redirect(
      "/api" +
        OrderController.path +
        `/complete?method=paypal&client_secret=${PAYPAL_SECRET}&total=${total}`
    );
  }
}

export default PaymentController;
