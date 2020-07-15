class Loadline {
  String loadno;
  String packingslipid;
  String salesid;
  String customer;
  String custname;
  String weightkg;
  String loadstatus;

  Loadline(
      {this.loadno,
      this.packingslipid,
      this.salesid,
      this.customer,
      this.custname,
      this.weightkg,
      this.loadstatus});

  Loadline.fromJson(Map<String, dynamic> json) {
    loadno = json['LOADNO'];
    packingslipid = json['PACKINGSLIPID'];
    salesid = json['SALESID'];
    customer = json['CUSTOMER'];
    custname = json['CUSTNAME'];
    weightkg = json['WEIGHTKG'];
    loadstatus = json['LOADSTATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LOADNO'] = this.loadno;
    data['PACKINGSLIPID'] = this.packingslipid;
    data['SALESID'] = this.salesid;
    data['CUSTOMER'] = this.customer;
    data['CUSTNAME'] = this.custname;
    data['WEIGHTKG'] = this.weightkg;
    data['LOADSTATUS'] = this.loadstatus;
    return data;
  }
}
