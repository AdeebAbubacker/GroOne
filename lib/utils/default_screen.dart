import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/routing/app_route_name.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: genericErrorWidget(
        error: GenericError(),
        onRefresh: (){
          context.push(AppRouteName.splash);
        }
      ),
    );
  }
}
