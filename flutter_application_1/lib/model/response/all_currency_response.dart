
class AllCurrency {
  bool? success;
  List<AllCurrencyItem>? allCurrency;

  AllCurrency({this.success, this. allCurrency});

  AllCurrency.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
       allCurrency = <AllCurrencyItem>[];
      json['result'].forEach((v) {
        allCurrency!.add(new AllCurrencyItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this. allCurrency != null) {
      data['result'] = this. allCurrency!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCurrencyItem {
  String? name;
  String? code;
  num? buying;
  String? buyingstr;
  num? selling;
  String? sellingstr;
  num? rate;
  String? time;
  String? date;
  String? datetime;
  num? calculated;

  AllCurrencyItem(
      {this.name,
      this.code,
      this.buying,
      this.buyingstr,
      this.selling,
      this.sellingstr,
      this.rate,
      this.time,
      this.date,
      this.datetime,
      this.calculated});

  AllCurrencyItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    buying = json['buying'];
    buyingstr = json['buyingstr'];
    selling = json['selling'];
    sellingstr = json['sellingstr'];
    rate = json['rate'];
    time = json['time'];
    date = json['date'];
    datetime = json['datetime'];
    calculated = json['calculated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['buying'] = this.buying;
    data['buyingstr'] = this.buyingstr;
    data['selling'] = this.selling;
    data['sellingstr'] = this.sellingstr;
    data['rate'] = this.rate;
    data['time'] = this.time;
    data['date'] = this.date;
    data['datetime'] = this.datetime;
    data['calculated'] = this.calculated;
    return data;
  }
}