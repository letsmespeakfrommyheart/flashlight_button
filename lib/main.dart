import 'package:flashlight_button/textOn.dart';
import 'package:flashlight_button/textOff.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const AnimationFlashlight());
}

class AnimationFlashlight extends StatelessWidget {
  const AnimationFlashlight({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashLightApp(),
    );
  }
}

class FlashLightApp extends StatefulWidget {
  const FlashLightApp({Key? key}) : super(key: key);

  @override
  FlashLightAppState createState() => FlashLightAppState();
}

class FlashLightAppState extends State<FlashLightApp>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 500);
  late final AnimationController controller;
  late final Animation<Color?> animation;
  bool isTurnOn = false;

  @override
  void initState() {
    super.initState();
    isTurnOn = false;
    controller = AnimationController(vsync: this, duration: _duration);
    animation =
        ColorTween(begin: Colors.grey, end: Colors.yellow).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isFlashlightAvailable(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            return AnimatedContainer(
              duration: _duration,
              curve: Curves.linear,
              height: double.infinity,
              color: isTurnOn ? Colors.white : Colors.black,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return GestureDetector(
                                onTap: () async {
                                  if (controller.status ==
                                      AnimationStatus.completed) {
                                    controller.reverse().whenComplete(() {
                                      setState(() {
                                        isTurnOn = !isTurnOn;
                                        _disableFlashlight(context);
                                      });
                                    });
                                  } else {
                                    controller.forward().whenComplete(() {
                                      setState(() {
                                        isTurnOn = !isTurnOn;
                                        _enableFlashlight(context);
                                      });
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  height: 200,
                                  width: 200,
                                  decoration: ShapeDecoration(
                                      image: const DecorationImage(
                                          fit: BoxFit.none,
                                          image: AssetImage(
                                              'assets/images/power-button.png')),
                                      shape: const CircleBorder(),
                                      color: isTurnOn
                                          ? Colors.grey.shade400
                                          : Colors.yellow),
                                  duration: _duration,
                                  curve: Curves.linear,
                                ),
                              );
                            })),
                    const SizedBox(height: 30),
                    Container(
                      child: isTurnOn ? const TextOff() : const TextOn(),
                    )
                  ]),
            );
          } else if (snapshot.hasData) {
            return const Center(
              child: Text('No flashlight available.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<bool> _isFlashlightAvailable(BuildContext context) async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      _showMessage(
        'Could not check if the device has an available flashlight',
        context,
      );
      rethrow;
    }
  }

  Future<void> _enableFlashlight(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      _showMessage('Could not enable flashlight', context);
    }
  }

  Future<void> _disableFlashlight(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showMessage('Could not disable flashlight', context);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
