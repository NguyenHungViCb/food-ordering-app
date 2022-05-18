class VoucherModel {
  constructor(
    public code: string,
    public valid_from: Date,
    public valid_until: Date,
    public discount: number
  ) {}
}

class VoucherCreation extends VoucherModel {
  constructor(
    public id: number,
    public code: string,
    public valid_from: Date,
    public valid_until: Date,
    public discount: number,
    public description?: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(code, valid_from, valid_until, discount);
  }
}

class VoucherDetailModel {
  constructor(public voucher_id: number, public product_id: number) {}
}

class VoucherDetailCreation extends VoucherDetailModel {
  constructor(
    public id: number,
    public voucher_id: number,
    public product_id: number
  ) {
    super(voucher_id, product_id);
  }
}

export {
  VoucherModel,
  VoucherCreation,
  VoucherDetailModel,
  VoucherDetailCreation,
};
