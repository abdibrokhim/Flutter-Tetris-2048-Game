import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final Widget child;

  const GameButton({
    super.key, 
    required this.child,
    });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 50.0,
        // padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}