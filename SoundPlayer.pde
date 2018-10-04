
import ddf.minim.*; // Import Sound Library

class SoundPlayer {
  Minim minimplay;
  AudioSample boomPlayer, popPlayer, firePlayer;
  AudioPlayer gameOverPlayer, youWinPlayer;

  SoundPlayer(Object app) {
    minimplay = new Minim(app); 
    boomPlayer = minimplay.loadSample("explode.wav", 1024); 
    popPlayer = minimplay.loadSample("pop.wav", 1024);
    firePlayer = minimplay.loadSample("fire.wav", 1024);
    gameOverPlayer = minimplay.loadFile("gameOver.wav");
    youWinPlayer = minimplay.loadFile("youWin.wav");
    
  }

  void playExplosion() {
    boomPlayer.trigger();
  }

  void playPop() {
    popPlayer.trigger();
  }
  
  void playFire()
  {
    firePlayer.trigger();
  }
  
  void stopFire()
  {
    firePlayer.stop();
  }
  
  void playGameOver()
  {
    gameOverPlayer.play();
  }
  
  void playYouWin()
  {
    youWinPlayer.play();
  }
}