import 'package:airplane_management/bloc/airplane_bloc.dart';
import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:airplane_management/models/airplane_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Practice extends StatelessWidget {
  const Practice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirplaneCubit()..fetchAirplaneData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Practice Page'),
        ),
        body: BlocBuilder<AirplaneCubit, AirplaneState>(
            builder: (context, state) {
          if (state is AirplaneLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AirplaneLoaded) {
            final AirplaneModel? airplaneData = state.airplaneModel;
            return ListView.builder(
                itemCount: airplaneData?.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(index.toString()),
                    ),
                    title: Text(
                        '${airplaneData?.data[index].departure!.airport!}'),
                    subtitle:
                        Text('${airplaneData?.data[index].arrival?.airport!}'),
                  );
                });
            // ListView(

            // );
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
