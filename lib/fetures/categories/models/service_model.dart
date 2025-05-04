class ServiceModel {
  String? id, name, description, price, status, icon, cover;
  List? requirements;

  ServiceModel(
      {required this.description,
      required this.id,
      required this.name,
      required this.price,
      required this.status,
      required this.cover,
      required this.icon,
      required this.requirements});

  ServiceModel.fromJson({required Map json, required String languageCode}) {
    id = json["id"].toString();
    name = json["name"][languageCode];
    description = json["description"][languageCode];
    price = json["price"];
    status = json["status"];
    icon = json["icon"];
    cover = json["cover_photo"];
    requirements = json["requirements"];
  }
}
