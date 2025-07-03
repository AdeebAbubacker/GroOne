import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/service/analytics_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  @override
  void initState() {
    super.initState();
    logScreenView();
  }


  void logScreenView() {
    analyticsHelper.logScreenView(widget.toString(), T.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    CustomLog.info(this, "Disposed Called");
    super.dispose();
  }

}