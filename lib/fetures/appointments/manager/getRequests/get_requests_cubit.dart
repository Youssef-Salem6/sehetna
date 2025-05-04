import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sehetna/constants/apis.dart';

part 'get_requests_state.dart';

class GetRequestsCubit extends Cubit<GetRequestsState> {
  GetRequestsCubit() : super(GetRequestsInitial());

  List requests = [];
  List filteredRequests = []; // For storing filtered results

  // Method to fetch all requests
  getRequests() async {
    // emit(GetRequestsLoading());
    Uri url = Uri.parse(getRequestsApi);
    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      requests = jsonDecode(response.body)["data"];
      filteredRequests = List.from(requests); // Initialize filtered list
      if (requests.isEmpty) {
        emit(GetRequestsEmpty());
      } else {
        emit(GetRequestsSuccess());
      }
    } else {
      emit(GetRequestsFailure(error: jsonDecode(response.body)["message"]));
    }
  }

  // Method to filter requests based on search query
  void searchRequests(String query) {
    if (query.isEmpty) {
      // If query is empty, show all requests
      filteredRequests = List.from(requests);
    } else {
      // Filter based on service name, provider name, status, etc.
      filteredRequests = requests.where((request) {
        final serviceNameEn =
            request['service']['name']['en'].toString().toLowerCase();
        final serviceNameAr =
            request['service']['name']['ar'].toString().toLowerCase();
        final status = request['status'].toString().toLowerCase();
        final providerFirstName = request['assigned_provider']?['first_name']
                ?.toString()
                .toLowerCase() ??
            '';
        final providerLastName = request['assigned_provider']?['last_name']
                ?.toString()
                .toLowerCase() ??
            '';

        final queryLower = query.toLowerCase();

        return serviceNameEn.contains(queryLower) ||
            serviceNameAr.contains(queryLower) ||
            status.contains(queryLower) ||
            providerFirstName.contains(queryLower) ||
            providerLastName.contains(queryLower) ||
            "$providerFirstName $providerLastName".contains(queryLower);
      }).toList();
    }
    emit(GetRequestsSuccess()); // Notify UI to rebuild with filtered results
  }
}
