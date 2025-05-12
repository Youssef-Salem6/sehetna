class ComplainModel {
  String? id, subject, description, status, createdAt, response;

  ComplainModel({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.status,
    required this.subject,
    required this.response,
  });

  ComplainModel.fromjson({required Map json}) {
    id = json["id"].toString();
    status = json["status"];
    response = json["response"];
    subject = json["subject"];
    description = json["description"];
    createdAt = json["created_at"] ?? "2025-05-02 19:22:29";
  }
}
