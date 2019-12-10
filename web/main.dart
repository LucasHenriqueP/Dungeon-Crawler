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
  resourceManager.addBitmapData("closed_door", "images/dngn_closed_door.png");
  resourceManager.addBitmapData("tela", "images/tela.png");
  resourceManager.addBitmapData("btnTeste", "images/dngn_enter_shop.png");
  await resourceManager.load();

  var logoData = resourceManager.getBitmapData("dart");
  // var paredeData = resourceManager.getBitmapData("parede");
  // var chaoData = resourceManager.getBitmapData("chao");
  var playerData = resourceManager.getBitmapData("player");
  // var corredorData = resourceManager.getBitmapData("corredor");
  // var bauFechadoMapaData = resourceManager.getBitmapData("bauFechadoMapa");
  // var bauAbertoMapaData = resourceManager.getBitmapData("bauAbertoMapa");
  var monstroData = resourceManager.getBitmapData("monstro");
  var spr = resourceManager.getBitmapData("btnTeste");

  var listaImagens = new Map();
  listaImagens['parede_corredor_parede'] =  resourceManager.getBitmapData("parede_corredor_parede"); 
  listaImagens['parede_corredor_porta'] =  resourceManager.getBitmapData("parede_corredor_porta"); 
  listaImagens['parede_parede_parede'] =  resourceManager.getBitmapData("parede_parede_parede"); 
  listaImagens['parede_parede_porta'] =  resourceManager.getBitmapData("parede_parede_porta"); 
  listaImagens['porta_corredor_parede'] =  resourceManager.getBitmapData("porta_corredor_parede"); 
  listaImagens['porta_corredor_porta'] =  resourceManager.getBitmapData("porta_corredor_porta"); 
  listaImagens['porta_parede_parede'] =  resourceManager.getBitmapData("porta_parede_parede"); 
  listaImagens['porta_parede_porta'] =  resourceManager.getBitmapData("porta_parede_porta"); 
  listaImagens['bau_fechado'] =  resourceManager.getBitmapData("bau_fechado"); 
  listaImagens['bau_aberto'] =  resourceManager.getBitmapData("bau_aberto"); 
  listaImagens['bau_fechado_mapa'] =  resourceManager.getBitmapData("bau_fechado_mapa"); 
  listaImagens['parede'] =  resourceManager.getBitmapData("parede"); 
  listaImagens['chao'] =  resourceManager.getBitmapData("chao"); 
  listaImagens['stone_black'] =  resourceManager.getBitmapData("stone_black"); 
  listaImagens['closed_door'] =  resourceManager.getBitmapData("closed_door"); 
  listaImagens['tela'] =  resourceManager.getBitmapData("tela"); 
 
  Parede tela = new Parede(listaImagens['tela'], stage, 0, 0, 'tela');
  var m1 = mapa1();
  Mapa mapa = Mapa(m1, listaImagens, stage);
  await mapa.setItem(Armor("Espada de aço bruto", -2, 0, 0, 0, 15));
  await mapa.setItem(Armor("Armadura de aço bruto", 0, 0, 15, 0, -2));
  await mapa.setItem(Armor("Espada de madeira maciça", 0, 0, 0, 2, 5));
  await mapa.setItem(Armor("Armadura de madeira maciça", 0, 0, 5, 0, 0));
  // mapa.setItem(Armor("Poção verde", -2, 0, 0, 0, 15));
  // mapa.setItem(Armor("Poção azul", -2, 0, 0, 0, 15));
  // mapa.setItem(Armor("Poção vermelha", -2, 0, 0, 0, 15));
  // Armor(var descricao, int accuracy, int critical, int defense, int dexterity, int damage);


  await mapa.draw(); // Desenha todo o mapa
  await mapa.drawBlack(); // Deixa o mapa escuro
  Player player = Player(playerData, stage, 752, 64, mapa);

  player.mouseCursor = MouseCursor.POINTER;
  FPV fpv = FPV(stage, mapa.mapa, listaImagens);
    var a = Parede(spr, stage, 1000, 500, null);
    a.parede.onMouseDown.listen(onSpriteSelected);
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
      parede.width = 640;
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
    this.posicaoCorredor = Point(32, 32);
    this.posicaoBau = Point(289, 272);
    this.fpv.setCorredor(posicaoCorredor, player.posicao);
    this.mapa.removeBlack(Point(1, 0));
    window.onKeyUp.listen(_onKeyUp);
  }
  void _onKeyUp(var ke) {
    bool moveu = false;
    switch(ke.keyCode){
      case ARROW_LEFT:
        player.posicao.y -= 1;
        if( !this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao) ){
            player.x -= 32;
            moveu = true;
        }else{
          player.posicao.y +=1;
        }
        break;

      case ARROW_UP:
        player.posicao.x -= 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.y -= 32;
            moveu = true;
        }else{
          player.posicao.x +=1;
        }
        break;

      case ARROW_RIGHT:
        player.posicao.y += 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.x += 32;
            moveu = true;
        }else{
          player.posicao.y -=1;
        }
        break;

      case ARROW_DOWN:
        player.posicao.x += 1;
        if(!this.mapa.checkBorder(player.posicao) && !this.mapa.isWall(player.posicao)){
            player.y += 32;
            moveu = true;
        }else{
          player.posicao.x -=1;
        }
        break;
        
      default:
        break;          
    }
    if(moveu){
      this.fpv.setCorredor(posicaoCorredor, player.posicao);
      if(this.mapa.mapa[player.posicao.x][player.posicao.y] == "B"){
        this.fpv.setBau(posicaoBau); // mostra bau na tela fpv
        // mostra o que tem no bau
        // escolhe o que tem no bau
      } else if(this.mapa.mapa[player.posicao.x][player.posicao.y] == "E"){
        // mostra inimigo no fpv
        // escolhe entre atacar, fugir ou usar poção
      }
      this.mapa.removeBlack(Point(player.posicao.x, player.posicao.y));

      // Verifica se tem inimigo
        // Se tiver faz a batalha

      // verifica se tem porta
        // se tiver

    }
  }
}

class Player extends Sprite{
  Stage stage;
  Point posicao = Point(1, 1);
  Mapa mapa;
  Stats stats;
  Armor armor;
  Armor weapon;
  List<void> inventory = new List(6);

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

class Enemy {
  Stats stats;
  var frase;

  Enemy(Stats stats, var frase){
    this.stats = stats;
    this.frase = frase;
  }
}

class Bau{
  var item1;
  var item2;
  var tem; // indica o que ainda tem no bau
  Point posicao;

  Bau(Point posicao, var item1, var item2){
    this.posicao = posicao;
    this.item1 = item1;
    this.item2 = item2;
    this.tem = 3;
  }
}

class Mapa {
  var mapa;
  var imagens;
  Stage stage;
  List baus;
  List itens;
  var _mapa = makeMatrix(30, 30);
  Mapa(m, var imagens, Stage s){
    this.mapa = m;
    this.imagens = imagens;
    this.stage = s;
    this.baus = [];
    this.itens = [];
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
          _mapa[i][j] = (Parede(imagens['parede'], stage, j*32+720, i*32+32, "mapa"));
        }
        else if(this.mapa[i][j] == "C" || this.mapa[i][j] == "E"){
          _mapa[i][j] = (Parede(imagens['chao'], stage, j*32+720, i*32+32, "mapa"));
        }
        else if(this.mapa[i][j] == "B"){
          _mapa[i][j] = (Parede(imagens['chao'], stage, j*32+720, i*32+32, "mapa"));
          _mapa[i][j] = (Parede(imagens['bau_fechado_mapa'], stage, j*32+720, i*32+32, "mapa"));
          this.setBau(Point(i, j));
          for(int k = 0; k < this.baus.length; k++){
            print(this.baus[k].item1.descricao);
            print(this.baus[k].item2.descricao);  
          }
        }
        else if(this.mapa[i][j] == "D"){
          _mapa[i][j] = (Parede(imagens['chao'], stage, j*32+720, i*32+32, "mapa"));
          _mapa[i][j] = (Parede(imagens['closed_door'], stage, j*32+720, i*32+32, "mapa"));
        }
      }
    }
  }
  void drawBlack(){
    for (var i = 0; i < this.mapa.length; i++) {
      for(var j = 0; j < this.mapa[i].length; j++){
        _mapa[i][j] = (Parede(imagens['stone_black'], stage, j*32+720, i*32+32, "escuro"));
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
  void setBau(Point p){
    Random rnd = new Random();
    var r1 = rnd.nextInt(6);
    var r2 = rnd.nextInt(6);
    baus.add(new Bau(p, this.itens[r1], this.itens[r2]));
    print("foi");
  }
  void setItem(var item){
    this.itens.add(item);
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
  List baus;
  FPV(Stage s, var mapa, var imagens){
    this.stage = s;
    this.mapa = mapa;
    this.imagens = imagens;
    this.baus = [];
  }
  // Desenha corredor
  void setCorredor(Point posicaoCorredor, Point p /*posicao player*/){
    if((p.x >= 14) || (p.x <= 0) || (p.y >= 14) || (p.y <= 0)) {
      print("oi");
    }
    else if ((this.mapa[p.x-1][p.y] == "X") && (this.mapa[p.x][p.y+1] != "X") && (this.mapa[p.x+1][p.y] == "X")){
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
  void setBau(Point posicaoBau){
    this.bauFechado.addChild(Bitmap (this.imagens['bau_fechado']));
    bauFechado.width = 127;
    bauFechado.height = 127;
    bauFechado.x = posicaoBau.x; 
    bauFechado.y = posicaoBau.y;
    stage.addChild(bauFechado);
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

class Armor {
  var descricao;
  int accuracy;
  int critical;
  int defense;
  int dexterity;
  int damage;

  Armor(var descricao, int accuracy, int critical, int defense, int dexterity, int damage){
    this.descricao = descricao;
    this.accuracy = accuracy;
    this.critical = critical;
    this.defense = defense;
    this.dexterity = dexterity;
    this.damage = damage;
  }
}

class Stats {
  int hp;
  int damage;
  int defense;
  int accuracy;
  int critical;
  int dexterity;
  int xp;

  Stats(int hp, int xp, int accuracy, int critical, int defense, int dexterity, int damage){
    this.hp = hp;
    this.accuracy = accuracy;
    this.critical = critical;
    this.defense = defense;
    this.dexterity = dexterity;
    this.damage = damage;
    this.xp = xp;
  }
}

class Battle {
  Enemy enemy;
  Player player;
  int max_critical;

  Battle(Enemy enemy, Player player) {
    this.enemy = enemy;
    this.player = player;
    this.max_critical = 100;
  }

  playerAtack(){
    int plyDamage = this.player.stats.damage + this.player.weapon.damage + this.player.armor.damage;
    int plyAccuracy = this.player.stats.accuracy + this.player.weapon.accuracy + this.player.armor.accuracy;
    int plyCritical = this.player.stats.critical + this.player.weapon.critical + this.player.armor.critical;
    int critical = 1;

    /* Gerando numero aleatorio */
    int minimo = 1;
    int maximo = max_critical;
    Random rnd = new Random();
    var r = minimo + rnd.nextInt(maximo - minimo);

    if (r <= plyCritical) {
      critical = 2; // dobra força do ataque
    }

    // destreza em evadir ataque vs acurácia em acertá-lo
    // ex: enemy.dexterity = 15 e plyAccuracy = 5:
    // jogador tem 33% de chance de acertar ataque
    minimo = 1;
    maximo = this.enemy.stats.dexterity;
    rnd = new Random();
    r = minimo + rnd.nextInt(maximo - minimo);

    if (r <= plyAccuracy) {
      int damage = plyDamage * critical - this.enemy.stats.defense;
      damage = max(damage, 0); // impede que dano seja negativo
      this.enemy.stats.hp -= damage;
      print("Jogador ataca o inimigo, causando $damage de dano.");
    } else {
      print("Jogador erra ataque.");
    }
  }

  enemyAtack(){
    int plyDefense = this.player.stats.defense + this.player.weapon.defense + this.player.armor.defense;
    int plyDexterity = this.player.stats.dexterity + this.player.weapon.dexterity + this.player.armor.dexterity;
    int critical = 1;
    
    /* Gerando numero aleatorio */
    int minimo = 1;
    int maximo = max_critical;
    Random rnd = new Random();
    var r = minimo + rnd.nextInt(maximo - minimo);

    if (r <= enemy.stats.critical) {
      critical = 2; // dobra força do ataque
    }
    // destreza em evadir ataque vs acurácia em acertá-lo
    // ex: plyDexterity = 15 e enemy.accuracy = 5:
    // inimigo tem 33% de chance de acertar ataque
    minimo = 1;
    maximo = plyDexterity;
    rnd = new Random();
    r = minimo + rnd.nextInt(maximo - minimo);

    if (r <= this.enemy.stats.accuracy) {
      int damage = this.enemy.stats.accuracy * critical - plyDefense;
      damage = max(damage, 0); // impede que dano seja negativo
      this.player.stats.hp -= damage;
      print("Inimigo ataca o jogador, causando $damage de dano.");
    } else {
      print("Inimigo erra ataque.");  
    }
  }
}

makeMatrix(m, n) {
   var x = new List.generate(m, (_) => new List(n));
   return x;
}

void onSpriteSelected(InputEvent inputEvent) {
  print("{inputEvent.localX}, {inputEvent.localY}");
}

class Texto extends DisplayObjectContainer {

  final String text = 
'Filet mignon leberkas pig pork chop biltong, short loin strip steak turkey brisket ' 
'venison. Pastrami venison pancetta, leberkas pork chop chicken prosciutto beef ribs '
'bresaola kielbasa swine biltong capicola. Hamburger beef ribs ball tip drumstick salami '  
'pig. Capicola pork loin shank, salami chicken hamburger tail. Sirloin spare ribs '
'ground round cow strip steak prosciutto swine bacon corned beef.';

  Texto() {
    
    var textField1 = new TextField();
    var textFormat1 = new TextFormat('Helvetica,Arial', 14, Color.Green, bold:true, italic:true);
    textField1.defaultTextFormat = textFormat1;
    textField1.text = text;
    textField1.x = 10;
    textField1.y = 10;
    textField1.width = 920;
    textField1.height = 20;
    addChild(textField1);
  }
}