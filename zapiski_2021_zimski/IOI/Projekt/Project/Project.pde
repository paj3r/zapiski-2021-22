import processing.core.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

  Minim minim;
  AudioPlayer player;
  FFT fftr;
  FFT fftl;
  //[#610061,#8300bf,#4d00ff,#0051ff,#00d0ff,#00ff34,#78ff00,#dfff00,#ffb300,#ff2600,#ff0000,#e00000]
  color colours [] = {#610061,#8300bf,#4d00ff,#0051ff,#00d0ff,#00ff34,#78ff00,#dfff00,#ffb300,#ff2600,#ff0000,#e00000};
  int counter=1;
  float [] avgr = new float [1025];
  float [] avgl = new float [1025];
  public void setup() {
    size(700, 700);  
    smooth();

      minim = new Minim(this);
      //player = minim.loadFile("../media/03 - Spaghettification.mp3",2048);
      //player = minim.loadFile("../media/piano-moment-9835.mp3",2048);
      player = minim.loadFile("../media/Get Back (1969 Glyn Johns Mix).mp3",2048);
      player.play();
      fftr = new FFT( player.bufferSize(), player.sampleRate() );
      fftl = new FFT( player.bufferSize(), player.sampleRate() );
  }
  public void draw() {
    //background(0);
    stroke(255);
    strokeWeight(1);
    fftl.forward(player.left);
    fftr.forward(player.right);
    if (counter%8 == 0){
      int rmaxix = 0;
      int lmaxix = 0;
      for(int i = 0; i<avgr.length; i++){
          if (avgr[rmaxix]<avgr[i]){
            rmaxix = i;
          }
      }
      for(int i = 0; i<avgl.length; i++){
          if (avgl[lmaxix]<avgl[i]){
            lmaxix = i;
          }
      }
      if (avgl[lmaxix] > avgr[rmaxix]){
        myline(map((avgl[lmaxix]-avgr[lmaxix])/avgl[lmaxix],0,1,350, width-350), map(player.position(),0,player.length(),0,700), (int)avgl[lmaxix]*4, 4,lmaxix);
      }else{
        myline(map((avgr[rmaxix]-avgl[rmaxix])/avgr[rmaxix],0,1,350, width-350), map(player.position(),0,player.length(),0,700), (int)avgr[rmaxix]*4, 4,rmaxix);
      }
      avgr = new float [1025];
      avgl = new float [1025];
    }else{
      for (int i=0;i<avgr.length;i++){
        avgr[i] += fftr.getBand(i)/8;
        avgl[i] += fftl.getBand(i)/8;
      }
    }
    counter++;
    /*
    for(int i = 0; i < fftr.specSize(); i++){
      // draw the line for frequency band i, scaling it up a bit so we can see it
      if (fftr.getBand(i)>5 && fftr.getBand(i+i+1)>4){
        stroke(204, 102, 0,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }else
     {  
       stroke(255,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }
      line(width,height-(i*2), width-(fftr.getBand(i)*2),height-i*2 );
    }
    for(int i = 0; i < fftl.specSize(); i++){
      // draw the line for frequency band i, scaling it up a bit so we can see it
      if (fftl.getBand(i)>5 && fftl.getBand(i+i+1)>4){
        stroke(204, 102, 0,255*(fftl.getBand(i+i+1)/fftl.getBand(i)));
      }else
     {  
       stroke(255,255*(fftr.getBand(i+i+1)/fftr.getBand(i)));
      }
      line(0,height-(i*2), fftl.getBand(i)*2,height-i*2 );
    }
    */
   }
   public void myline(float centerx, float centery, int radius, int colour, int angle){
      stroke(colours[colour]);
      PVector center = new PVector(centerx, centery);
      float x = center.x + cos(radians(angle))*radius/2;
      float y = center.y + sin(radians(angle))*radius/2;
      line(center.x, center.y, x, y);
      x = center.x + cos(radians(angle+180))*radius/2;
      y = center.y + sin(radians(angle+180))*radius/2;
      line(center.x, center.y, x, y);
  }
