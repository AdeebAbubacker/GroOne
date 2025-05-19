 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';

import 'dependency_injection/locator.dart';
import 'features/choose_role_screen/bloc/role_bloc.dart';


class MultiBlocWrapper extends StatelessWidget {
  final Widget child;

  const MultiBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (_) => locator<LanguageBloc>()),
        BlocProvider<RoleBloc>(create: (_) => locator<RoleBloc>()),
       ],
      child: child,
    );
  }
}
