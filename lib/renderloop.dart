// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameWidget extends StatefulWidget {
  final GameScene scene;
  GameWidget(this.scene, {super.key}) {
    runApp(this);
  }

  @override
  State createState() => GameState();
}

class GameState extends State<GameWidget> with SingleTickerProviderStateMixin {
  int _dt = 0;
  Duration _elapsed = Duration.zero;
  late final Ticker _ticker;
  late bool _started;

  // Game Loop
  @override
  void initState() {
    super.initState();
    _started = false;
    _ticker = createTicker((elapsed) {
      setState(() {});
      _dt = (elapsed - _elapsed).inMilliseconds;
      _elapsed = elapsed;
      _started = widget.scene.started;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Loop',
      home: buildCanvasContainer(),
      showPerformanceOverlay: false,
    );
  }

  Widget buildCanvasContainer() {
    return Scaffold(
        body: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(child: buildCanvasPainter(context)),
      ]),
    ));
  }

  Widget buildCanvasPainter(BuildContext context) {
    if (_started) {
      return CustomPaint(
        //willChange: true,
        painter: ScenePainter(widget.scene, _dt),
        child: Container(),
      );
    }
    return const CustomPaint();
  }
}

class ScenePainter extends CustomPainter {
  final int _dt;
  final GameScene _scene;
  ScenePainter(this._scene, this._dt);

  @override
  void paint(Canvas canvas, Size size) {
    _scene.render(canvas, size, _dt);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Game extends GameWidget {
  Game(GameScene scene, {super.key}) : super(scene);

  void start() {
    scene.start();
  }
}

class GameScene {
  bool started = false;
  GameScene();

  void render(Canvas canvas, Size size, int dt) {
    //
  }

  void loadAssets() {
    //
  }

  void start() {
    started = true;
  }
}
