import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF2D2D2D),
              Color(0xFF3A3A3A),
              Color(0xFF4F4F4F),
              Color(0xFF636363),
              Color(0xFF7A7A7A),
              Color(0xFF919191),
              Color(0xFFA6A6A6),
              Color(0xFFBBBBBB),
              Color(0xFFD0D0D0),
              Color(0xFFE6E6E6),
              Color(0xFFFBFBFB),
            ],
          ),
        ),
        child: this.child,
      ),
    );
  }
}
