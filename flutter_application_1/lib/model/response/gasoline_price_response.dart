class GasolinePriceResponse {
  List<GasolinePriceItem>? gasolinePrices;
  String? lastupdate;
  bool? success;

  GasolinePriceResponse({this.gasolinePrices, this.lastupdate, this.success});

  GasolinePriceResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      gasolinePrices = <GasolinePriceItem>[];
      json['result'].forEach((v) {
        gasolinePrices!.add(new GasolinePriceItem.fromJson(v));
      });
    }
    lastupdate = json['lastupdate'];
    success = json['success'];
  }

  get gasolinePriceResponse => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gasolinePrices != null) {
      data['result'] = this.gasolinePrices!.map((v) => v.toJson()).toList();
    }
    data['lastupdate'] = this.lastupdate;
    data['success'] = this.success;
    return data;
  }
}

class GasolinePriceItem {
  String? marka;
  double? benzin;
  dynamic? katkili;

  GasolinePriceItem({this.marka, this.benzin, this.katkili});

  GasolinePriceItem.fromJson(Map<String, dynamic> json) {
    marka = json['marka'];
    benzin = json['benzin'];
    katkili = json['katkili'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marka'] = this.marka;
    data['benzin'] = this.benzin;
    data['katkili'] = this.katkili;
    return data;
  }
}
