class VoucherModel {
  constructor(
    public code: string,
    public valid_from: Date,
    public valid_until: Date
  ) {}
}

class VoucherCreation extends VoucherModel {
  constructor(
    public id: number,
    public code: string,
    public valid_from: Date,
    public valid_until: Date,
    public description?: string,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(code, valid_from, valid_until);
  }
}

export { VoucherModel, VoucherCreation };
