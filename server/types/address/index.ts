class AddressModel {
  constructor(
    public address: string,
    public ward: string,
    public district: string,
    public city: string,
    public is_primary: boolean
  ) {}
}

class AddressCreation extends AddressModel {
  constructor(
    public id: number,
    public user_id: number,
    public address: string,
    public ward: string,
    public district: string,
    public city: string,
    public is_primary: boolean,
    public created_at?: Date,
    public updated_at?: Date
  ) {
    super(address, ward, district, city, is_primary);
  }
}

export { AddressModel, AddressCreation };
