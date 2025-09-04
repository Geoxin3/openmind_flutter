import 'package:flutter/material.dart';

//this is not used now
//is a custom progress loader 
class CustomAnimatedLoader extends StatefulWidget {
  const CustomAnimatedLoader({super.key});

  @override
  State<CustomAnimatedLoader> createState() => _CustomAnimatedLoaderState();
}

class _CustomAnimatedLoaderState extends State<CustomAnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
