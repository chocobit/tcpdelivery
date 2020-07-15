class ChkLogin {
  String hpglicenseplate;
  String hpgtransportationtypecode;
  String hpgtransportcode;
  String driver;
  String remark;
  String active;

  ChkLogin(
      {this.hpglicenseplate,
      this.hpgtransportationtypecode,
      this.hpgtransportcode,
      this.driver,
      this.remark,
      this.active});

  ChkLogin.fromJson(Map<String, dynamic> json) {
    hpglicenseplate = json['hpglicenseplate'];
    hpgtransportationtypecode = json['hpgtransportationtypecode'];
    hpgtransportcode = json['hpgtransportcode'];
    driver = json['driver'];
    remark = json['remark'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hpglicenseplate'] = this.hpglicenseplate;
    data['hpgtransportationtypecode'] = this.hpgtransportationtypecode;
    data['hpgtransportcode'] = this.hpgtransportcode;
    data['driver'] = this.driver;
    data['remark'] = this.remark;
    data['active'] = this.active;
    return data;
  }
}
