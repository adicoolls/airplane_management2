import 'package:airplane_management/models/airplane_model.dart';

abstract class AirplaneState {}

class AirplaneInitial extends AirplaneState {}

class AirplaneLoading extends AirplaneState {}

class AirplaneLoaded extends AirplaneState {
  AirplaneModel? airplaneModel;
  AirplaneLoaded({required this.airplaneModel});
}

class AirplaneError extends AirplaneState {
  final String errorMessage;

  AirplaneError({required this.errorMessage});
}
