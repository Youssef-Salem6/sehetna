import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'services_list_state.dart';

class ServicesListCubit extends Cubit<ServicesListState> {
  ServicesListCubit() : super(ServicesListInitial());

  List<String> selectedServices = [];
  double cost = 0;

  addServiceToList({required String id, required double price}) {
    selectedServices.add(id);
    cost += price;
  }

  removeServiceFromList({required String id, required double price}) {
    cost -= price;
    selectedServices.remove(id);

  }

  clearList() {
    selectedServices.clear();
    cost = 0;

  }
}
