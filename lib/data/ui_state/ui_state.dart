import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/enum/status.dart';

class UIState<T>{

  Status? status;
  T? data;
  ErrorType? errorType;

  UIState(this.status, this.data, this.errorType);

  UIState.loading() :  status = Status.LOADING;
  UIState.success(this.data) :  status = Status.SUCCESS;
  UIState.error(this.errorType) :  status = Status.ERROR;

  @override
  String toString(){
    return "Status : $status \n Message : $errorType \n Data : ${data.toString()}";
  }
}