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
  // resourceManager.addBitmapData("bauAbertoMapa", "images/chest2_open.png");
  resourceManager.addBitmapData("monstro", "images/boss.jpeg");
  resourceManager.addBitmapData("parede_corredor_parede", "images/corredor/parede_corredor_parede.png");
  resourceManager.addBitmapData("parede_corredor_porta", "images/corredor/parede_corredor_porta.png");
  resourceManager.addBitmapData("parede_parede_parede", "images/corredor/parede_parede_parede.png");
  resourceManager.addBitmapData("parede_parede_porta", "images/corredor/parede_parede_porta.png");
  resourceManager.addBitmapData("porta_corredor_parede", "images/corredor/porta_corredor_parede.png");
  resourceManager.addBitmapData("porta_corredor_porta", "images/corredor/porta_corredor_porta.png");
  resourceManager.addBitmapData("porta_parede_parede", "images/corredor/porta_parede_parede.png");
  resourceManager.addBitmapData("porta_parede_porta", "images/corredor/porta_parede_porta.png");
  resourceManager.addBitmapData("bau_fechado", "images/chestClose.png");
  resourceManager.addBitmapData("bau_aberto", "images/chestOpen.png");
  resourceManager.addBitmapData("bau_fechado_mapa", "images/chest2_closed.png");
  resourceManager.addBitmapData("stone_black", "images/stone_black.png");
  await resourceManager.load();

  var logoData = resourceManager.getBitmapData("dart");
  // var paredeData = resourceManager.getBitmapData("parede");
  // var chaoData = resourceManager.getBitmapData("chao");
  var playerData = resourceManager.getBitmapData("player");
  // var corredorData = resourceManager.getBitmapData("corredor");
  // var bauFechadoMapaData = resourceManager.getBitmapData("bauFechadoMapa");
  // var bauAbertoMapaData = resourceManager.getBitmapData("bauAbertoMapa");
  var monstroData = resourceManager.getBitmapData("monstro");

  var listaImagens = new Map();
  listaImagens['parede_corredor_parede'] = resourceManager.getBitmapData("parede_corredor_parede"); 
  listaImagens['parede_corredor_porta'] = resourceManager.getBitmapData("parede_corredor_porta"); 
  listaImagens['parede_parede_parede'] = resourceManager.getBitmapData("parede_parede_parede"); 
  listaImagens['parede_parede_porta'] = resourceManager.getBitmapData("parede_parede_porta"); 
  listaImagens['porta_corredor_parede'] = resourceManager.getBitmapData("porta_corredor_parede"); 
  listaImagens['porta_corredor_porta'] = resourceManager.getBitmapData("porta_corredor_porta"); 
  listaImagens['porta_parede_parede'] = resourceManager.getBitmapData("porta_parede_parede"); 
  listaImagens['porta_parede_porta'] = resourceManager.getBitmapData("porta_parede_porta"); 
  listaImagens['bau_fechado'] = resourceManager.getBitmapData("bau_fechado"); 
  listaImagens['bau_aberto'] = resourceManager.getBitmapData("bau_aberto"); 
  listaImagens['bau_fechado_mapa'] = resourceManager.getBitmapData("bau_fechado_mapa"); 
  listaImagens['parede'] = resourceManager.getBitmapData("parede"); 
  listaImagens['chao'] = resourceManager.getBitmapData("chao"); 
  listaImagens['stone_black'] = resourceManager.getBitmapData("stone_black"); 
 
  var m1 = mapa1();
  Mapa mapa = Mapa(m1, listaImagens, stage);
  mapa.draw(); // Desenha todo o mapa
  mapa.drawBlack(); // Deixa o mapa escuro

  Player player = Player(playerData, stage, 720, 32, mapa);

  player.mouseCursor = MouseCursor.POINTER;
  FPV fpv = FPV(stage, mapa.mapa, listaImagens);

  Game game = Game(player, mapa, fpv);

  // See more examples:
  // https://github.com/bp74/StageXL_Samples
  // var logo = Sprite();
  // logo.addChild(Bitmap(logoData));
  // stage.onKeyDown.listen(movePersonagem);
  // logo.pivotX = logoData.width / 2;
  // logo.pivotY = logoData.height / 2;

  // // Place it at top center.
  // logo.x = 1280 / 2;
  // logo.y = 0;

  // stage.addChild(logo);

  // // And let it fall.
  // var tween = stage.juggler.addTween(logo, 3, Transition.easeOutBounce);
  // tween.animate.y.to(800 / 2);

  // // Add some interaction on mouse click.
  // Tween rotation;
  // logo.onMouseClick.listen((MouseEvent e) {
  //   // Don't run more rotations at the same time.
  //   if (rotation != null) return;
  //   rotation = stage.juggler.addTween(logo, 0.5, Transition.easeInOutCubic);
  //   rotation.animate.rotation.by(2 * pi);
  //   rotation.onComplete = () => rotation = null;
  // });
  // logo.mouseCursor = MouseCursor.POINTER;

  // See more examples:
  // https://github.com/bp74/StageXL_Samples
}



class Parede {
  Sprite parede =  Sprite();
  Stage stage;
  var tipo;
  Parede(paredeData, this.stage, posX, posY, var tipo){
    parede.addChild(Bitmap (paredeData));
    parede.x = posX;
    parede.y = posY;
    this.tipo = tipo;
    this.desenha();
  }
  void desenha(){
    if(this.tipo == "corredor"){
      parede.width = 480;
      parede.height = 480;
    }
    stage.addChild(parede);
  }
}

class Game {
  Player player;
  Mapa mapa;
  FPV fpv;
  Point posicaoCorredor;
  Point posicaoBau;
  Game(Player player, Mapa mapa, FPV fpv){
    this.player = player;
    this.mapa = mapa;
    this.fpv = fpv;
    this.posicaoCorredor = Point(0, 0);
    this.posicaoBau = Point(175, 240);
    this.fpv.setCorredor(posicaoCorredor, Point(player.posicao.x, player.posicao.y));
    this.mapa.removeBlack(Point(1, 0));
    window.onKeyUp.listen(_onKeyUp);
  }
  void _onKeyUp(var ke) {
    switch(ke.keyCode){
      case ARROW_LEFT:
        player.posicao.y -= 1;
        if( !this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao) ){
            player.x -= 32;
            this.fpv.setCorredor(posicaoCorredor, Point(player.posicao.x, player.posicao.y));
            this.fpv.setBau(posicaoBau, Point(player.posicao.x, player.posicao.y));
            this.mapa.removeBlack(Point(player.posicao.x, player.posicao.y));
        }else{
          player.posicao.y +=1;
        }
        break;

      case ARROW_UP:
        player.posicao.x -= 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.y -= 32;
            this.fpv.setCorredor(posicaoCorredor, Point(player.posicao.x, player.posicao.y));
            this.fpv.setBau(posicaoBau, Point(player.posicao.x, player.posicao.y));
            this.mapa.removeBlack(Point(player.posicao.x, player.posicao.y));
        }else{
          player.posicao.x +=1;
        }
        break;

      case ARROW_RIGHT:
        player.posicao.y += 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.x += 32;
            this.fpv.setCorredor(posicaoCorredor, Point(player.posicao.x, player.posicao.y));
            this.fpv.setBau(posicaoBau, Point(player.posicao.x, player.posicao.y));
            this.mapa.removeBlack(Point(player.posicao.x, player.posicao.y));
        }else{
          player.posicao.y -=1;
        }
        break;

      case ARROW_DOWN:
        player.posicao.x += 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.y += 32;
            this.fpv.setCorredor(posicaoCorredor, Point(player.posicao.x, player.posicao.y));
            this.fpv.setBau(posicaoBau, Point(player.posicao.x, player.posicao.y));
            this.mapa.removeBlack(Point(player.posicao.x, player.posicao.y));
        }else{
          player.posicao.x -=1;
        }
        break;
        
      default:
        break;          
    }
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
    this.mapa = map;
    this.desenha();
  }
  void desenha(){
    this.mapa.isWall(this.posicao);
    stage.addChild(this);
  }
}

class Mapa {
  var mapa;
  var imagens;
  Stage stage;
  var _mapa = makeMatrix(30, 30);
  Mapa(m, var imagens, Stage s){
    this.mapa = m;
    this.imagens = imagens;
    this.stage = s;
  }
  void setMapa(var m){
    this.mapa = m;
  }
  void getMapa(){
    return this.mapa;
  }
  void whatIs(){

  }
  bool isWall(Point p){
    if(mapa[p.x][p.y] == "X"){
      return true;
    }else{
      return false;
    }
  }
  void removeBlack(Point p){
    for (var i = (p.x)-2; i < (p.x)+2; i++) {
      if(i < 0) i=0;
      if(i > 14) break;
      for(var j = (p.y)-2; j < (p.y)+2; j++){
        if(j < 0) j=0;
        if(j > 14) break;
        if(_mapa[i][j].tipo == "escuro"){
          _mapa[i][j].tipo = "mapa";
          this.stage.removeChild(_mapa[i][j].parede);
        }
      }
    }
  }
  void draw(){
    for (var i = 0; i < this.mapa.length; i++) {
      for(var j = 0; j < this.mapa[i].length; j++){
          if(this.mapa[i][j] == "X"){
            _mapa[i][j] = (Parede(imagens['parede'], stage, j*32+720, i*32, "mapa"));
          }
          else if(this.mapa[i][j] == "C"){
            _mapa[i][j] = (Parede(imagens['chao'], stage, j*32+720, i*32, "mapa"));
          }
          else if(this.mapa[i][j] == "B"){
            _mapa[i][j] = (Parede(imagens['chao'], stage, j*32+720, i*32, "mapa"));
            _mapa[i][j] = (Parede(imagens['bau_fechado_mapa'], stage, j*32+720, i*32, "mapa"));
          }
      }
    }
  }
  void drawBlack(){
    for (var i = 0; i < this.mapa.length; i++) {
      for(var j = 0; j < this.mapa[i].length; j++){
        _mapa[i][j] = (Parede(imagens['stone_black'], stage, j*32+720, i*32, "escuro"));
      }
    }
  }
  bool checkBorder(Point p){
    print("check");
    print(p);
    if((p.x >= 15) || (p.x < 0) || (p.y >= 15) || (p.y < 0)){
      print("Deu true");
      return true;
    }
    print("deu false");
    return false;
  }
}

class FPV {
  Stage stage;
  var mapa;
  // Sprite corredor = Sprite();
  Sprite bauFechado = Sprite();
  Sprite bauAberto = Sprite();
  Sprite inimigo = Sprite();
  var corredor;
  var imagens;
  FPV(Stage s, var mapa, var imagens){
    this.stage = s;
    this.mapa = mapa;
    this.imagens = imagens;
  }
  // Desenha corredor
  void setCorredor(Point posicaoCorredor, Point p /*posicao player*/){
    if((this.mapa[p.x-1][p.y] == "X") && (this.mapa[p.x][p.y+1] != "X") && (this.mapa[p.x+1][p.y] == "X")){
      this.corredor = Parede(this.imagens['parede_corredor_parede'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] == "X") && (this.mapa[p.x][p.y+1] != "X") && (this.mapa[p.x+1][p.y] != "X")){
      this.corredor = Parede(this.imagens['parede_corredor_porta'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] == "X") && (this.mapa[p.x][p.y+1] == "X") && (this.mapa[p.x+1][p.y] == "X")){
      this.corredor = Parede(this.imagens['parede_parede_parede'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] == "X") && (this.mapa[p.x][p.y+1] == "X") && (this.mapa[p.x+1][p.y] != "X")){
      this.corredor = Parede(this.imagens['parede_parede_porta'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] != "X") && (this.mapa[p.x][p.y+1] != "X") && (this.mapa[p.x+1][p.y] == "X")){
      this.corredor = Parede(this.imagens['porta_corredor_parede'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] != "X") && (this.mapa[p.x][p.y+1] != "X") && (this.mapa[p.x+1][p.y] != "X")){
      this.corredor = Parede(this.imagens['porta_corredor_porta'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] != "X") && (this.mapa[p.x][p.y+1] == "X") && (this.mapa[p.x+1][p.y] == "X")){
      this.corredor = Parede(this.imagens['porta_parede_parede'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
    else if((this.mapa[p.x-1][p.y] != "X") && (this.mapa[p.x][p.y+1] == "X") && (this.mapa[p.x+1][p.y] != "X")){
      this.corredor = Parede(this.imagens['porta_parede_porta'], this.stage, posicaoCorredor.x, posicaoCorredor.y, "corredor");
    }
  }
  void setBau(Point posicaoBau, Point p){
    if(this.mapa[p.x][p.y] == "B"){
      this.bauFechado.addChild(Bitmap (this.imagens['bau_fechado']));
      bauFechado.width = 127;
      bauFechado.height = 127;
      bauFechado.x = posicaoBau.x; 
      bauFechado.y = posicaoBau.y;
      stage.addChild(bauFechado);
    }
  }
  // void setInimigo(var data){
  //   inimigo.addChild(Bitmap (data));
  // }
  // void desenhaBauAberto(Point p){
  //   bauAberto.width = bauAberto.width / 2;
  //   bauAberto.height = bauAberto.height / 2;
  //   bauAberto.x = p.x;
  //   bauAberto.y = p.y;
  //   stage.addChild(bauAberto);
  // }
  // void desenhaBauFechado(Point p){
  //   bauFechado.width = bauFechado.width / 2;
  //   bauFechado.height = bauFechado.height / 2;
  //   bauFechado.x = p.x; 
  //   bauFechado.y = p.y;
  //   stage.addChild(bauFechado);
  // }
  // void removeBauAberto(){
  //   stage.removeChild(bauAberto);
  // }
  // void removeBauFechado(){
  //   stage.removeChild(bauFechado);
  // }
  // void desenhaInimigo(Point p){
  //   inimigo.x = p.x;
  //   inimigo.y = p.y;
  //   stage.addChild(inimigo);
  // }
}

makeMatrix(m, n) {
   var x = new List.generate(m, (_) => new List(n));
   return x;
}

void movePersonagem(e){
  print(e);
}