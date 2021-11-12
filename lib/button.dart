import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final String text;
  final onPress;

  const Button({required this.text,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 50,
        child:  MaterialButton(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed:
          onPress,
          child:Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
