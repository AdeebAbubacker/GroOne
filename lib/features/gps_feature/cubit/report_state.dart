part of 'report_cubit.dart';

 class GpsReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportInitial extends GpsReportState {}

class ReportLoading extends GpsReportState {}

class ReportLoaded extends GpsReportState {
  final List<Report> reports;

  ReportLoaded(this.reports);

  @override

  List<Object?> get props => [reports];
}

class ReportError extends GpsReportState {
  final String message;

  ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
