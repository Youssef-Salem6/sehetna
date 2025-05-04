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
    print(selectedServices);
    print(cost);
  }

  removeServiceFromList({required String id, required double price}) {
    cost -= price;
    selectedServices.remove(id);
    print(selectedServices);
    print(cost);
  }

  clearList() {
    selectedServices.clear();
    cost = 0;
    print(selectedServices);
    print(cost);
  }
}
