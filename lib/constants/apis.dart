import 'package:sehetna/main.dart';

Map<String, String> header = {
  'Authorization': 'Bearer ${pref.getString("token")}',
  "Accept": "application/json",
};
String baseUrl = "https://api.sehtnaa.com/api";
String imagesBaseUrl = "https://api.sehtnaa.com/storage";
String authBaseIrl = "$baseUrl/auth";
String resetPasswordBase = "$baseUrl/reset-password";
String userBase = "$baseUrl/user";

//Auth

String registerApi = "$authBaseIrl/register";
String logOutApi = "$authBaseIrl/logout";
String loginApi = "$authBaseIrl/login";
String sendCodeApi = "$resetPasswordBase/send-code";
String otpApi = "$resetPasswordBase/verify-code";
String resetPasswordApi = "$resetPasswordBase/reset";

//user

String updateFcmTokenApi = "$userBase/update-fcm-token";
String updateLocationApi = "$userBase/update-location";
String updateProfileApi = "$userBase/update-profile";
String updateProfileImageApi = "$userBase/update-profile-image";
String updatePasswordApi = "$userBase/update-password";
String getOngoingRequestsApi = "$userBase/ongoing-requests";
String deleteAccountApi = "$userBase/delete-account";

// Categories
String getAllCategoriesApi = "$baseUrl/categories";

//requests
String getRequestsApi = "$baseUrl/requests";
