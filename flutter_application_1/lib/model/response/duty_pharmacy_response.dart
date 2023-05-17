class DutyPharmacy {
  bool? success;
  List<DutyPharmacyItem>? dutyPharmacy;

  DutyPharmacy({this.success, this.dutyPharmacy});

  DutyPharmacy.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
     dutyPharmacy = <DutyPharmacyItem>[];
      json['result'].forEach((v) {
       dutyPharmacy!.add(new DutyPharmacyItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.dutyPharmacy != null) {
      data['result'] = this.dutyPharmacy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DutyPharmacyItem {
  String? name;
  String? dist;
  String? address;
  String? phone;
  String? loc;

 DutyPharmacyItem({this.name, this.dist, this.address, this.phone, this.loc});

 DutyPharmacyItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dist = json['dist'];
    address = json['address'];
    phone = json['phone'];
    loc = json['loc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dist'] = this.dist;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['loc'] = this.loc;
    return data;
  }
}