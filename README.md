#  Flutter Minimal Render Loop

  

Open a new file `main.dart`

Import here at least `material.dart` in order to get the canvas drawing methods and import the file `renderloop.dart`

Then create your own class extending `GameScene`, say, class `MysScene`.

In this class, declare all your instance variables that describe the game state.

Then implement the method `render(Canvas canvas, Size size, int dt)` overriding the `render()` GameScene method.

This `render()` method is called each frame and is passed :

-  the canvas in which the drawing is done

-  the size of this canvas

-  the delta time dt between this frame and the previous one as an integer in milliseconds

  

Initialization :

1 - Create an object from your `GameScene` extended class.

2 - Create a game object with this scene :

3 - Run the game

  
```code
void main() {

GameScene scene = MyScene();

Game game = Game(scene);

game.run();

}
```

