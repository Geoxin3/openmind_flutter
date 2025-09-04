import 'package:flutter/material.dart';

//right to left transition
PageRouteBuilder customPageRoute(Widget page) {
   return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      var slideTransition = SlideTransition(position: offsetAnimation, child: child);

      return slideTransition;
    },
  );
}

//bottom to top navigation transition 
class CustomPageRoutepop extends PageRouteBuilder {
  final Widget page;
  CustomPageRoutepop(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.2, 1.0); // Page starts from the bottom
            const end = Offset.zero;        // Page ends in the center (normal position)
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

//fade navigation transition
class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  FadePageRoute(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
