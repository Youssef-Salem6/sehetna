class FeedbackModel {
  String? id, rating, comment, createdAt, userName, userImage;

  FeedbackModel({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.rating,
    required this.userImage,
    required this.userName,
  });

  FeedbackModel.fromJson({required Map json}) {
    id = json[id];
    comment = json["comment"];
    rating = json["rating"].toString();
    userImage = json["user"]['profile_image'];
    userName = json["user"]["name"];
    createdAt = json["created_at"];
  }
}
