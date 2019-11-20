import 'dart:async';
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'mapa1.dart';

const ARROW_LEFT = 37;
const ARROW_UP = 38;
const ARROW_RIGHT = 39;
const ARROW_DOWN = 40;

Future<Null> main() async {
  StageOptions options = StageOptions()
    ..backgroundColor = Color.White
    ..renderEngine = RenderEngine.WebGL;
  var canvas = querySelector('#stage');
  var stage = Stage(canvas, width: 1280, height: 800, options: options);

  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);
  var resourceManager = ResourceManager();
  resourceManager.addBitmapData("dart", "images/dart@1x.png");
  resourceManager.addBitmapData("parede", "images/stone_brick1.png");
  resourceManager.addBitmapData("chao", "images/floor_sand_stone2.png");
  resourceManager.addBitmapData("player", "images/unseen_horror.png");
  await resourceManager.load();


  var logoData = resourceManager.getBitmapData("dart");
  var paredeData = resourceManager.getBitmapData("parede");
  var chaoData = resourceManager.getBitmapData("chao");
  var playerData = resourceManager.getBitmapData("player");
  
  var logo = Sprite();
  var m1 = mapa1();
  var mapa = makeMatrix(30, 30);
  for (var i = 0; i < m1.length; i++) {
    for(var j = 0; j < m1[i].length; j++){
          if(m1[i][j] == "X"){
            mapa[i][j] = (Parede(paredeData, stage, j*32+720, i*32));
          }
          else if(m1[i][j] == "C"){
            mapa[i][j] = (Parede(chaoData, stage, j*32+720, i*32));
          }
    }
  }
  Player player = Player(playerData, stage, 720, 32);
  player.mouseCursor = MouseCursor.POINTER;
  // See more examples:
  // https://github.com/bp74/StageXL_Samples

  logo.addChild(Bitmap(logoData));
  stage.onKeyDown.listen(movePersonagem);
  logo.pivotX = logoData.width / 2;
  logo.pivotY = logoData.height / 2;

  // Place it at top center.
  logo.x = 1280 / 2;
  logo.y = 0;

  stage.addChild(logo);
  

  // And let it fall.
  var tween = stage.juggler.addTween(logo, 3, Transition.easeOutBounce);
  tween.animate.y.to(800 / 2);

  // Add some interaction on mouse click.
  Tween rotation;
  logo.onMouseClick.listen((MouseEvent e) {
    // Don't run more rotations at the same time.
    if (rotation != null) return;
    rotation = stage.juggler.addTween(logo, 0.5, Transition.easeInOutCubic);
    rotation.animate.rotation.by(2 * pi);
    rotation.onComplete = () => rotation = null;
  });
  logo.mouseCursor = MouseCursor.POINTER;

  // See more examples:
  // https://github.com/bp74/StageXL_Samples
}

class Parede {
  Sprite parede =  Sprite();
  Stage stage;
  Parede(paredeData, this.stage, posX, posY){
    parede.addChild(Bitmap (paredeData));
    parede.x = posX;
    parede.y = posY;
    this.desenha();
  }
  void desenha(){
    stage.addChild(parede);
  }
}

class Player extends Sprite{
  Stage stage;
  Player(playerData, this.stage, posX, posY){
    this.addChild(Bitmap (playerData));
    this.x = posX;
    this.y = posY;
    window.onKeyUp.listen(_onKeyUp);

    this.desenha();
  }
  void desenha(){
    stage.addChild(this);
  }
    void _onKeyUp(var ke) {
    switch(ke.keyCode){
      case ARROW_LEFT:
        this.x -= 32;
        break;
      case ARROW_UP:
        this.y -= 32;
        break;
      case ARROW_RIGHT:
        this.x += 32;
        break;
      case ARROW_DOWN:
        this.y += 32;
        break;
      default:
        break;          
    }
}
}




makeMatrix(m, n) {
   var x = new List.generate(m, (_) => new List(n));
   return x;
}

void movePersonagem(e){
  print(e);
}