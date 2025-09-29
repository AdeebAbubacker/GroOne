import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/ai_chat/cubit/chat_cubit.dart';
import 'package:gro_one_app/features/ai_chat/view/chat_screen.dart';

import '../routing/app_route_name.dart';

class ChatActionButton extends StatelessWidget {
  const ChatActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF64B5F6), // Light blue
            Color(0xFF1976D2), // Darker blue
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          context.push(AppRouteName.chaBotScreen);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BlocProvider.value(
          //       value: locator<ChatCubit>(),
          //       child: const ChatScreen(),
          //     ),
          //   ),
          // );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icons/gif/lntAnimateLogo.gif'),
        ),
      ),
    );
  }
}
