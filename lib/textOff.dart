import 'package:flutter/material.dart';

class TextOff extends StatelessWidget {
  const TextOff({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Turn off the flashlight',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Dosis',
            fontSize: 25,
            fontWeight: FontWeight.bold));
  }
}
