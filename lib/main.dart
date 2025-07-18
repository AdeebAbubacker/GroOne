import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/core/app_initializer.dart';
import 'package:gro_one_app/l10n/l10n.dart';
import 'package:gro_one_app/routing/app_routes.dart';
import 'package:gro_one_app/service/firebase_secondary_service.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/utils/app_theme_style.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/global_variables.dart';
import 'core/localization_bloc/localization_bloc.dart';
import 'core/localization_bloc/localization_state.dart';
import 'l10n/app_localizations.dart';
import 'multi_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  await FirebaseService.initializeSecondaryApp();
  runApp(BlocProvider(create: (_) => LocaleBloc(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initFun();
    super.initState();
  }

  initFun() => frameCallback(() async {
    await HasInternetConnection().checkConnectivity();
    // await authRepo.signOut();
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return MultiBlocWrapper(
          child: MaterialApp.router(
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: "Gro One",
            debugShowCheckedModeBanner: true,
            supportedLocales: L10n.all,
            theme: AppThemeStyle.appTheme,
            routerConfig: AppRoutes.router,
          ),
        );
      },
    );
  }
}
