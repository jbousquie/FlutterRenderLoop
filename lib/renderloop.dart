import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GameWidget extends StatefulWidget {
  final GameScene scene;
  const GameWidget(this.scene, {super.key});

  @override
  State createState() => GameState();
}

class GameState extends State<GameWidget> with SingleTickerProviderStateMixin {
  int _dt = 0;
  Duration _elapsed = Duration.zero;
  late final Ticker _ticker;

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
      painter: ScenePainter(widget.scene, _dt),
      child: Container(),
    );
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
  const Game(GameScene scene, {super.key}) : super(scene);
  void run() {
    runApp(this);
  }
}

class GameScene {
  const GameScene();

  void render(Canvas canvas, Size size, int dt) {
    //
  }
}
