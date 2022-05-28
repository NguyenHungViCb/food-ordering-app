export enum ORDER_STATUS {
  "pending" = "pending",
  "canceled" = "canceled",
  "succeeded" = "succeeded",
  "confirmed" = "confirmed",
  "processing" = "processing",
  "shipping" = "shipping"
}

export class OrderModel {
  constructor(
    public user_id: number,
    public address: string,
    public status: ORDER_STATUS,
    public payment_method: string,
    public payment_detail: string
  ) {}
}

export class OrderCreation extends OrderModel {
  constructor(
    public id: number,
    public user_id: number,
    public address: string,
    public status: ORDER_STATUS,
    public payment_method: string,
    public payment_detail: string,
    public voucher_id: number,
    public paid_at: Date,
    public canceled_at: Date,
    public created_at?: Date,
    public pudated_at?: Date
  ) {
    super(user_id, address, status, payment_method, payment_detail);
  }
}
