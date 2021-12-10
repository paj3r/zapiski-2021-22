import processing.core.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

  Minim minim;
  AudioPlayer player;
  FFT fftr;
  FFT fftl;
  public void setup() {
    size(1280, 720);  
    smooth();

      minim = new Minim(this);
      player = minim.loadFile("../media/03 - Spaghettification.mp3",512);
      player.play();
      fftr = new FFT( player.bufferSize(), player.sampleRate() );
      fftl = new FFT( player.bufferSize(), player.sampleRate() );
  }
  public void draw() {
    background(0);
    stroke(255);
    strokeWeight(3);
    fftl.forward(player.left);
    fftr.forward(player.right);
    print(fftr.getBand(0)+" ");
    for(int i = 0; i < fftr.specSize(); i++){
      // draw the line for frequency band i, scaling it up a bit so we can see it
      line(width,height-(i*2), width-fftr.getBand(i),height-i*2 );
    }
    for(int i = 0; i < fftl.specSize(); i++){
      // draw the line for frequency band i, scaling it up a bit so we can see it
      line(0,height-(i*2), fftl.getBand(i),height-i*2 );
    }

   }
