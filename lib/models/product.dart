class Product {
  List<Course> data;
  Meta meta;

  Product({this.data, this.meta});

  Product.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Course>();
      json['data'].forEach((v) {
        data.add(new Course.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class Course {
  int id;
  String title;
  String detail;
  String date;
  int view;
  String picture;

  Course({this.id, this.title, this.detail, this.date, this.view, this.picture});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    date = json['date'];
    view = json['view'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['date'] = this.date;
    data['view'] = this.view;
    data['picture'] = this.picture;
    return data;
  }
}

class Meta {
  String status;
  int statusCode;

  Meta({this.status, this.statusCode});

  Meta.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    return data;
  }
}