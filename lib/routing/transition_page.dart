import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Page<T> buildTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
  bool isForward = false,
}) {

  // Cupertino-style transition (iOS look)
  Page<T> cupertinoPage() =>
      CupertinoPage<T>(key: state.pageKey, child: child);


  // Custom slide transition (your original)
  Page<T> slidePage() {
    const begin = Offset(0.0, 1.5);
    const end = Offset.zero;
    const curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  if (isForward) {
    return cupertinoPage();
  }
  return slidePage();

}
