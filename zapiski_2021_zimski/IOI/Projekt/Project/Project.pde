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
      if (fftr.getBand(i)>5 && fftr.getBand(i+i+1)>2){
        stroke(204, 102, 0,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }else
     {  
       stroke(255,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }
      line(width,height-(i*2), width-(fftr.getBand(i)*3),height-i*2 );
    }
    for(int i = 0; i < fftl.specSize(); i++){
      // draw the line for frequency band i, scaling it up a bit so we can see it
      if (fftl.getBand(i)>5 && fftl.getBand(i+i+1)>2){
        stroke(204, 102, 0,255*(fftl.getBand(i+i+1)/fftl.getBand(i)));
      }else
     {  
       stroke(255,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }
      line(0,height-(i*2), fftl.getBand(i)*3,height-i*2 );
    }

   }
