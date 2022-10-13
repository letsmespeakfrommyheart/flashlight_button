import 'package:flutter/material.dart';

class TextOn extends StatelessWidget {
  const TextOn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Turn on the flashlight',
        style: TextStyle(
            color: Colors.yellow,
            fontFamily: 'Dosis',
            fontSize: 25,
            fontWeight: FontWeight.bold));
  }
}
