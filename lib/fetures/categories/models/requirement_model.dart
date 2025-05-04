class RequirementModel {
  String? id, name, type;

  RequirementModel({
    required this.id,
    required this.name,
    required this.type,
  });

  RequirementModel.fromJson({required Map json, required String languageCode}) {
    id = json["id"].toString();
    name = json["name"][languageCode];
    type = json["type"];
  }
}
