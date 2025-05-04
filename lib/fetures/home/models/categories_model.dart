class CategoriesModel {
  String? id, name, description, icon;
  int? isMultiaple;
  CategoriesModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.isMultiaple});
  CategoriesModel.fromJson(
      {required Map<String, dynamic> json, required String languageCode}) {
    id = json['id'].toString();
    name = json['name'][languageCode] ?? json['name']['en'];
    description =
        json['description'][languageCode] ?? json['description']['en'];
    icon = json['icon'];
    isMultiaple = json["is_multiple"];
  }
}
