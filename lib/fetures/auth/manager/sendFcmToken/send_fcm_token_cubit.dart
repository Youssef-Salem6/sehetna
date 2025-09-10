import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/push_notification_services.dart';
part 'send_fcm_token_state.dart';

class SendFcmTokenCubit extends Cubit<SendFcmTokenState> {
  SendFcmTokenCubit() : super(SendFcmTokenInitial());

  sendToken() async {
    emit(SendFcmTokenLoading());
    Uri? uri = Uri.parse(updateFcmTokenApi);
    try {
      var response = await http.post(
        uri,
        headers: header,
        body: {
          "fcm_token": PushNotificationServices.myToken,
          "device_type": "android"
        },
      );
      if (response.statusCode == 200) {
        emit(SendFcmTokenSuccess());
      } else if (response.statusCode == 400) {
        emit(SendFcmTokenFailure());
      } else {
        emit(SendFcmTokenFailure());
      }
    } catch (e) {
    }
  }
}
