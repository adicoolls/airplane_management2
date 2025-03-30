import 'package:airplane_management/bloc/airplane_bloc.dart';
import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Practice extends StatelessWidget {
  const Practice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Page'),
      ),
      body: BlocProvider(
        create: (context) => AirplaneCubit(),
        child: BlocBuilder<AirplaneCubit, AirplaneState>(
            builder: (context, state) {
          if (state is AirplaneLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AirplaneLoaded) {
            return Center(child: Text(state?.airplaneModel?.data[0].airline?.name));
          } else if (state is AirplaneError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Center(child: Text('Unknown state'));
          }
        }),
      ),
    );
  }
}
