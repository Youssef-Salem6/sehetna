class Servicedetailsmodel {
  String? id, name, price, category;

  Servicedetailsmodel(
      {required this.category,
      required this.id,
      required this.name,
      required this.price});

  Servicedetailsmodel.fromjson(
      {required Map json, required String languageCode}) {
    id = json["id"].toString();
    name = json["name"][languageCode];
    category = json["category"]["name"][languageCode];
    price = json["price"];
  }
}
