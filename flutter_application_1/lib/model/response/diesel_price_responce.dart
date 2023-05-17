


class DieselPriceResponse {
  List<DieselPriceItem>? dieselPrices;
  String? lastupdate;
  bool? success;

  DieselPriceResponse({this.dieselPrices, this.lastupdate, this.success});

  DieselPriceResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      dieselPrices = <DieselPriceItem>[];
      json['result'].forEach((v) {
       dieselPrices!.add(new DieselPriceItem.fromJson(v));
      });
    }
    lastupdate = json['lastupdate'];
    success = json['success'];
  }

  get dieselPriceResponse => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dieselPrices != null) {
      data['result'] = this.dieselPrices!.map((v) => v.toJson()).toList();
    }
    data['lastupdate'] = this.lastupdate;
    data['success'] = this.success;
    return data;
  }
}

class DieselPriceItem {
  String? marka;
  double? dizel;
  dynamic? katkili;

  DieselPriceItem({
    this.marka,
    this.dizel,
    this.katkili,
  });

 DieselPriceItem.fromJson(Map<String, dynamic> json) {
    marka = json['marka'];
    dizel = json['dizel'];
    katkili = json['katkili'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marka'] = this.marka;
    data['dizel'] = this.dizel;
    data['katkili'] = this.katkili;
    return data;
  }
}
