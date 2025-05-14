class Requestdetailsmodel {
  String? requestId;
  List? services;
  String? totalPrice, status, createdAt;
  String? customerId, customerImage, customerName, customerAge;
  String? customerPhone, customerGender;

  Requestdetailsmodel(
      {required this.createdAt,
      required this.customerAge,
      required this.customerGender,
      required this.customerId,
      required this.customerImage,
      required this.customerName,
      required this.customerPhone,
      required this.requestId,
      required this.services,
      required this.status,
      required this.totalPrice});

  Requestdetailsmodel.fromJson({required Map json}) {
    requestId = json["id"].toString();
    services = json["services"];
    totalPrice = json["total_price"];
    status = json["status"];
    createdAt = json["created_at"];
    Map customerData = json["customer"];
    customerId = customerData["id"].toString();
    customerImage = customerData["profile_image"];
    customerName = customerData["name"];
    customerAge = customerData["age"].toString();
    customerPhone = customerData["phone"];
    customerGender = customerData["gender"];
  }
}
