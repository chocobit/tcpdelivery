class Loadhead {
  String company;
  String lob;
  String loadno;
  String transdate;
  String hpgtransportcode;
  String routeid;
  String driver;
  String hpglicenseplate;
  String hpgtransprotationtypecode;
  String totalweight;
  String totallitre;
  String loadstatus;
  String leavingdatetime;
  String tel;
  String loadnote;
  String updatedby;
  String updateddate;
  String recid;

  Loadhead(
      {this.company,
      this.lob,
      this.loadno,
      this.transdate,
      this.hpgtransportcode,
      this.routeid,
      this.driver,
      this.hpglicenseplate,
      this.hpgtransprotationtypecode,
      this.totalweight,
      this.totallitre,
      this.loadstatus,
      this.leavingdatetime,
      this.tel,
      this.loadnote,
      this.updatedby,
      this.updateddate,
      this.recid});

  Loadhead.fromJson(Map<String, dynamic> json) {
    company = json['COMPANY'];
    lob = json['LOB'];
    loadno = json['LOADNO'];
    transdate = json['transdate'];
    hpgtransportcode = json['HPGTRANSPORTCODE'];
    routeid = json['ROUTEID'];
    driver = json['DRIVER'];
    hpglicenseplate = json['HPGLICENSEPLATE'];
    hpgtransprotationtypecode = json['HPGTRANSPORTATIONTYPECODE'];
    totalweight = json['TOTALWEIGHT'];
    totallitre = json['TOTALLITRE'];
    loadstatus = json['LOADSTATUS'];
    leavingdatetime = json['LEAVINGDATETIME'];
    tel = json['TEL'];
    loadnote = json['LOADNOTE'];
    updatedby = json['UPDATEDBY'];
    updateddate = json['UPDATEDDATE'];
    recid = json['RECID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COMPANY'] = this.company;
    data['LOB'] = this.lob;
    data['LOADNO'] = this.loadno;
    data['TRANSDATE'] = this.transdate;
    data['HPGTRANSPORTCODE'] = this.hpgtransportcode;
    data['ROUTEID'] = this.routeid;
    data['DRIVER'] = this.driver;
    data['HPGLICENSEPLATE'] = this.hpglicenseplate;
    data['HPGTRANSPORTATIONTYPECODE'] = this.hpgtransprotationtypecode;
    data['TOTALWEIGHT'] = this.totalweight;
    data['TOTALLITRE'] = this.totallitre;
    data['LOADSTATUS'] = this.loadstatus;
    data['LEAVINGDATETIME'] = this.leavingdatetime;
    data['TEL'] = this.tel;
    data['LOADNOTE'] = this.loadnote;
    data['UPDATEDBY'] = this.updatedby;
    data['UPDATEDDATE'] = this.updateddate;
    data['RECID'] = this.recid;
    return data;
  }
}
