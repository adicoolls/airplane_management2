import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:airplane_management/models/airplane_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirplaneCubit extends Cubit<AirplaneState> {
  AirplaneCubit() : super(AirplaneInitial());
  final Dio _dio = Dio();

  Future<void> fetchAirplaneData() async {
    try {
      emit(AirplaneLoading());
      Response response = await _dio.get(
          'https://api.aviationstack.com/v1/flights?access_key=61f50e151083003b80a3ceba346bed78');
      if (response.statusCode == 200) {
        AirplaneModel airplaneModel = AirplaneModel.fromJson(response.data);
        emit(AirplaneLoaded(airplaneModel: airplaneModel));
      } else {
        emit(AirplaneError(errorMessage: 'Failed to load data'));
      }
    } catch (e) {
      emit(AirplaneError(errorMessage: e.toString()));
    }
  }
}
