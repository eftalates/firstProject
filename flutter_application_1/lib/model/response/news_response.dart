class News {
  bool? success;
  List<NewsItem>? news;

  News({this.success, this.news});

  News.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      news = <NewsItem>[];
      json['result'].forEach((v) {
        news!.add(new NewsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.news != null) {
      data['result'] = this.news!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsItem {
  String? key;
  String? url;
  String? description;
  String? image;
  String? name;
  String? source;
  String? date;

  NewsItem(
      {this.key,
      this.url,
      this.description,
      this.image,
      this.name,
      this.source,
      this.date});

 NewsItem.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    url = json['url'];
    description = json['description'];
    image = json['image'];
    name = json['name'];
    source = json['source'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['url'] = this.url;
    data['description'] = this.description;
    data['image'] = this.image;
    data['name'] = this.name;
    data['source'] = this.source;
    data['date'] = this.date;
    return data;
  }
}