import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import "package:http/http.dart" as http;
part 'update_location_state.dart';

class UpdateLocationCubit extends Cubit<UpdateLocationState> {
  UpdateLocationCubit() : super(UpdateLocationInitial());

  updateLocation({
    required String latitude,
    required String longitude,
  }) async {
    Uri uri = Uri.parse(updateLocationApi);

    emit(UpdateLocationLoading());
    try {
      var response = await http.post(
        uri,
        headers: header,
        body: {
          "latitude": latitude,
          "longitude": longitude,
        },
      );
      if (response.statusCode == 200) {
        emit(UpdateLocationSuccess());
      } else if (response.statusCode == 401) {
        emit(UpdateLocationFailure());
      } else {
        emit(UpdateLocationFailure());
      }
    } catch (e) {
    }
  }
}
