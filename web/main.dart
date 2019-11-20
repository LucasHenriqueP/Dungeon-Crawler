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
    Mapa mapa = Mapa(m1, paredeData, chaoData, stage);
  mapa.draw();
  Player player = Player(playerData, stage, 720, 32, mapa);

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
  Point posicao = Point(1,  0);
  Mapa mapa;
  Player(playerData, this.stage, posX, posY, map){
    this.addChild(Bitmap (playerData));
    this.x = posX;
    this.y = posY;
    window.onKeyUp.listen(_onKeyUp);
    this.mapa = map;
    this.desenha();
  }
  void desenha(){
    this.mapa.isWall(this.posicao);
    stage.addChild(this);
  }
    void _onKeyUp(var ke) {
    switch(ke.keyCode){
      case ARROW_LEFT:
        this.posicao.y -= 1;
        print(this.posicao);
        if(!this.mapa.isWall(this.posicao) && !this.mapa.checkBorder(this.posicao)){
            this.x -= 32;
        }else{
          this.posicao.y +=1;
        }
        break;


      case ARROW_UP:
        this.posicao.x -= 1;
        if(!this.mapa.isWall(this.posicao) && !this.mapa.checkBorder(this.posicao)){
            this.y -= 32;
        }else{
          this.posicao.x +=1;
        }
        break;


      case ARROW_RIGHT:
        this.posicao.y += 1;
        if(!this.mapa.checkBorder(this.posicao) && !this.mapa.isWall(this.posicao)){
            this.x += 32;
        }else{
          this.posicao.y -=1;
        }
        break;


      case ARROW_DOWN:
        this.posicao.x += 1;
        if(!this.mapa.checkBorder(this.posicao) && !this.mapa.isWall(this.posicao)){
            this.y += 32;
        }else{
          this.posicao.x -=1;
        }
        break;


      default:
        break;          
    }
}
}

class Mapa {
  var mapa;
  var paredeData;
  var chaoData;
  Stage stage;
  var _mapa = makeMatrix(30, 30);
  Mapa(m, paredeD, chaoD, Stage s){
    this.mapa = m;
    this.paredeData = paredeD;
    this.chaoData = chaoD;
    this.stage = s;
  }
    void setMapa(var m){
    this.mapa = m;
  }
  void getMapa(){
    return this.mapa;
  }
  bool isWall(Point p){
    if(mapa[p.x][p.y] == "X"){
      return true;
    }else{
      return false;
    }
  }
  void draw(){
    for (var i = 0; i < this.mapa.length; i++) {
    for(var j = 0; j < this.mapa[i].length; j++){
          if(this.mapa[i][j] == "X"){
            _mapa[i][j] = (Parede(paredeData, stage, j*32+720, i*32));
          }
          else if(this.mapa[i][j] == "C"){
            _mapa[i][j] = (Parede(chaoData, stage, j*32+720, i*32));
          }
    }
  }
  }
  bool checkBorder(Point p){
    print("check");
    print(p);
    if((p.x >= 15 || p.x < 0) || (p.y >= 15 || p.y < 0)){
      print("Deu false");
      return true;
    }
    return false;
  }
}




makeMatrix(m, n) {
   var x = new List.generate(m, (_) => new List(n));
   return x;
}

void movePersonagem(e){
  print(e);
}