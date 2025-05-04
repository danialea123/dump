//var scoreboard = [
//  {
//    fullName: 'Loic Berry',
//    score: 1000
//  },
//  {
//    fullName: 'Max Monroe',
//    score: 200
//  },
//  {
//    fullName: 'La reine d\'angleterre la vieille',
//    score: 10
//  }
//]
var Scoreboard = []
function StartupScene(game) {
  this._game = game;
  this._pressEnterText = new PressEnterText();
  
  this._pacman = new Pacman(this, game);
  this._pacman.setStrategy(new PacmanStartupSceneStrategy(this._pacman, this));
  this._pacman.setCurrentSpeed(4);
  this._pacman.setSpeed(4);
  this._pacman.setPosition(new Position(90, 160));
  this._pacman.setDirection(DIRECTION_RIGHT);
}

StartupScene.prototype.keyPressed = function (key) {
  if (key == KEY_ENTER) {
    this._game.setScene(new PlayScene(this._game));
  }
};

StartupScene.prototype.tick = function () {
  this._pressEnterText.tick();
  this._pacman.tick();
};

StartupScene.prototype.draw = function (ctx) {
  this._drawTitle(ctx);
  this._drawControlsHelp(ctx);
  this._pressEnterText.draw(ctx);
  this._pacman.draw(ctx);
};

StartupScene.prototype.getX = function () {
  return 0;
};

StartupScene.prototype.getY = function () {
  return 0;
};

StartupScene.prototype._drawTitle = function (ctx) {
  ctx.fillStyle = "#ffff00";
  ctx.font = "bold 90px 'Lucida Console', Monaco, monospace"
  ctx.fillText("PAC-MAN", 76, 150);
};

window.addEventListener('message', (event) => {
  Scoreboard = event.data.scoreboard
});

StartupScene.prototype._drawControlsHelp = function (ctx) {

  ctx.fillStyle = "#dedede";
  ctx.font = "bold 14px 'Lucida Console', Monaco, monospace"
  ctx.fillText("CONTROL: ARROW KEYS", 187, 300);
  ctx.fillText("-- HIGH SCORE --", 200, 360);
  var index = 0;
  if (Scoreboard){
    Scoreboard.forEach((scoreData) => {
      ctx.fillText(scoreData.name + ": " + scoreData.score, 187, 390 + (index * 20));
      index++
    })
  }
};
