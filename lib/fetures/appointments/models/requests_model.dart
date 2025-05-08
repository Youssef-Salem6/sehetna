class RequestsModel {
  String? id, customerId, serviceId, phone, address, status, serviceName;
  String? price, name, providerType;
  String? providerimage, providerPhone, createdAt, categoryName;
  bool? hasfeedBack, hasCancellation;
  List? feedbacks, complaints, services;
  int? isMultiaple, categoryId;

  RequestsModel({
    required this.address,
    required this.customerId,
    required this.id,
    required this.phone,
    required this.price,
    required this.name,
    required this.providerPhone,
    required this.providerType,
    required this.providerimage,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.hasfeedBack,
    required this.hasCancellation,
    required this.complaints,
    required this.feedbacks,
    required this.createdAt,
    required this.services,
    required this.isMultiaple,
    required this.categoryId,
    required this.categoryName,
  });

  RequestsModel.fromJson({required Map json, required String languageCode}) {
    id = json["id"].toString();
    customerId = json["customer_id"].toString();
    serviceId = json["service_id"].toString();
    phone = json["phone"];
    address = json["address"];
    status = json["status"];
    feedbacks = json["feedbacks"];
    complaints = json["complaints"];
    hasfeedBack = json["has_feedback"];
    hasCancellation = json["has_cancellations"];
    serviceName = json["services"][0]["name"][languageCode];
    services = json["services"];
    price = json["total_price"];
    Map providerData = json["provider"] ??
        {
          "first_name": "Cancellation request",
          "last_name": "",
          "provider_type": "Sehetna",
          "phone": "No provider Assigned",
          "profile_image": "",
        };
    name = providerData["name"];
    providerType = providerData["provider_type"];
    providerPhone = providerData["phone"];
    providerimage = providerData["profile_image"];
    createdAt = json["created_at"];
    isMultiaple = json["services"][0]["category"]["is_multiple"];
    categoryId = json["services"][0]["category"]["id"];
    categoryName = json["services"][0]["category"]["name"][languageCode];
  }
}
