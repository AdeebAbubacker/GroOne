import 'package:flutter/material.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/utils/custom_log.dart';


class BaseNotifier extends ChangeNotifier {

  void setUIState<T>({required T Function(T?) update, required void Function(T) setState, T? currentState}) {
    final newState = update(currentState);
    if (newState != currentState) {
      setState(newState); // Explicitly update the state
      notifyListeners();
    }
  }

  // Reset UI & Data
  ///  Only pass response data model and if you are using another value to resets then please use [onReset] method. (no need to add [notifyListeners] in the end)
  void resetUIState<T>(UIState<T>? dataModel) {
    if (dataModel == null) return;
    if (dataModel.data is List) {
      (dataModel.data as List).clear();
    } else if (dataModel.data != null) {
      dataModel.data = null;
    }
    dataModel.status = Status.INITIAL;
    dataModel.errorType = null;
    CustomLog.debug(this, "\n--- Reset UI State ( Data model : ${T.toString()} ) ---  \nUI Status : ${dataModel.status.toString()}, \nError Type : ${dataModel.errorType}, \nData : ${dataModel.data}");
    notifyListeners();
  }

}
