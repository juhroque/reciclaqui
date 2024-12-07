import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String buttonText; // New property for button text

  const DefaultButton({required this.buttonText}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 287,
      height: 48.70136260986328,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF538001),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 16,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
