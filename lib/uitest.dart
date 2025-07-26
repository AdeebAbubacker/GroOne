import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';

class Uitest extends StatelessWidget {
   Uitest({super.key});
final profileCubit = locator<ProfileCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ElevatedButton(onPressed: () async{
          await profileCubit.fetchDriver();
        }, child: Text("Call"))
      ],),
    ),);
  }
}