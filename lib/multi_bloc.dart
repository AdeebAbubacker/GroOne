import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';

import 'dependency_injection/locator.dart';
import 'features/choose_role_screen/bloc/role_bloc.dart';
import 'features/kyc/bloc/kyc_bloc.dart';
import 'features/load_provider/lp_create_account/bloc/lp_create_bloc.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/otp_verification/bloc/otp_bloc.dart';

class MultiBlocWrapper extends StatelessWidget {
  final Widget child;

  const MultiBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (_) => locator<LanguageBloc>()),
        BlocProvider<RoleBloc>(create: (_) => locator<RoleBloc>()),
        BlocProvider<LoginBloc>(create: (_) => locator<LoginBloc>()),
        BlocProvider<OtpBloc>(create: (_) => locator<OtpBloc>()),
        BlocProvider<VpCreationBloc>(create: (_) => locator<VpCreationBloc>()),
        BlocProvider<LpCreateBloc>(create: (_) => locator<LpCreateBloc>()),
        BlocProvider<KycBloc>(create: (_) => locator<KycBloc>()),
      ],
      child: child,
    );
  }
}
