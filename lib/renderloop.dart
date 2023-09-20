import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});
  @override
  State createState() => GameState();
}

class GameState extends State<GameWidget> with SingleTickerProviderStateMixin {
  int _dt = 0;
  Duration _elapsed = Duration.zero;
  late final Ticker _ticker;
  late final GameScene scene;

  // Game Loop
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {});
      _dt = (elapsed - _elapsed).inMilliseconds;
      _elapsed = elapsed;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Game Loop', home: buildCanvasContainer());
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
    return CustomPaint(
      //willChange: true,
      painter: ScenePainter(_dt),
      child: Container(),
    );
  }
}

class ScenePainter extends CustomPainter {
  final int _dt;
  ScenePainter(this._dt);

  @override
  void paint(Canvas canvas, Size size) {
    scene.render(canvas, size, _dt);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Game extends GameWidget {
  const Game({super.key});

  void run(GameScene gameScene) {
    runApp(this);
  }
}

class GameScene {
  void render(Canvas canvas, Size size, int dt) {
    // To be overridden
  }
}
