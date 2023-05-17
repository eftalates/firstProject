class LpgPriceResponse {
  String? lastupdate;
  List<LpgPriceItem>? lpgPrices;
  bool? success;

  LpgPriceResponse({this.lastupdate, this.lpgPrices, this.success});

  LpgPriceResponse.fromJson(Map<String, dynamic> json) {
    lastupdate = json['lastupdate'];
    if (json['result'] != null) {
      lpgPrices = <LpgPriceItem>[];
      json['result'].forEach((v) {
        lpgPrices!.add(new LpgPriceItem.fromJson(v));
      });
    }
    success = json['success'];
  }

  get lpgPriceResponse => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastupdate'] = this.lastupdate;
    if (this.lpgPrices != null) {
      data['result'] = this.lpgPrices!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class LpgPriceItem {
  String? lpg;
  String? marka;

  LpgPriceItem({this.lpg, this.marka});

  LpgPriceItem.fromJson(Map<String, dynamic> json) {
    lpg = json['lpg'];
    marka = json['marka'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lpg'] = this.lpg;
    data['marka'] = this.marka;
    return data;
  }
}
