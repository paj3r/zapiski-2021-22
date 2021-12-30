import processing.core.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

  Minim minim;
  AudioPlayer player;
  FFT fftr;
  FFT fftl;
  boolean fin = false;
  boolean exit = false;
  String outname;
  //[#610061,#8300bf,#4d00ff,#0051ff,#00d0ff,#00ff34,#78ff00,#dfff00,#ffb300,#ff2600,#ff0000,#e00000]
  color colours [] = {#610061,#8300bf,#4d00ff,#0051ff,#00d0ff,#00ff34,#78ff00,#dfff00,#ffb300,#ff2600,#ff0000,#e00000};
  int counter=1;
  float min;
  float max;
  float [] avgr;
  float [] avgl;
  String filename;
  float avgvolr = 0f;
  float avgvoll = 0f;
  float prev = 100f;
  int winsize = 32;
  float[] frequencies = {32.703f,34.648f,36.708f,38.891f,41.203f,43.654f,46.249f,49f,51.931f,55f,58.270f,61.735f, 65.406f, 69.296f,73.416f, 77.782f,82.407f,87.307f,92.499f,
      97.999f, 103.83f, 110f,116.64f, 123.47f, 130.81f, 138.59f, 146.83f, 155.56f, 164.81f, 174.61f, 185.00f, 196.00f,207.65f, 220.00f, 233.08f, 246.94f, 261.6f, 277.18f,
      293.66f, 311.1f, 329.63f, 349.2f, 369.99f, 392.00f, 415.3f, 440.00f, 466.2f, 493.88f, 523.3f, 554.37f, 587.33f
      ,622.3f, 659.25f, 698.5f, 739.99f, 783.99f,830.6f, 880.00f, 932.3f, 987.77f, 1046.5f, 1108.7f, 1174.7f, 1244.5f, 1318.5f, 1396.9f,
      1480.0f, 1568.0f, 1661.2f, 1760.0f, 1864.7f, 1975.5f};  
  int sampleRate = 44100;
  int frameSize = 4096;
  public void setup() {
    size(900, 900);  
    smooth();
    background(255);
      //player = minim.loadFile("../media/03 - Spaghettification.mp3",frameSize);
      //player = minim.loadFile("../media/piano-moment-9835.mp3",frameSize);
      //player = minim.loadFile("../media/Get Back (1969 Glyn Johns Mix).mp3",frameSize);
      //player = minim.loadFile("../media/Toxic.mp3",frameSize);
      //player = minim.loadFile("../media/DJ Gumja - Seki Prasica (Original Mix) TECHSTURB050.mp3",frameSize);
      //player = minim.loadFile("../media/Phaxe & Morten Granau - Beatless.mp3",frameSize);
      selectInput("Select a file to process:", "fileSelected");
  }
  void fileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
      exit();
    } else {
      println("User selected " + selection.getAbsolutePath());
      filename = stripExtension(selection.getName());
      minim = new Minim(this);
      player = minim.loadFile(selection.getAbsolutePath(),frameSize);
      player.play();
      fftr = new FFT( player.bufferSize(), player.sampleRate() );
      fftl = new FFT( player.bufferSize(), player.sampleRate() );
      min = Float.MAX_VALUE;
      max = Float.MIN_VALUE;
      avgr = new float[fftr.specSize()];
      avgl = new float[fftl.specSize()];
      winsize = ceil((int)player.length()/9000)+2;
      println(winsize);
    }
  }
  void fileSelectedOut(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
      exit();
    } else {
      println("User selected " + selection.getAbsolutePath());
      outname = selection.getAbsolutePath() + "\\" + filename + ".png";
      save(outname);
      exit=true;
    }
  }
  public void draw() {
    //background(0);
    stroke(255);
    strokeWeight(1);
    if (fftl!=null && fftr!=null){
      fftr.window(FFT.HAMMING);
      fftl.window(FFT.HAMMING);
      fftl.forward(player.left);
      fftr.forward(player.right);
      if (counter%winsize == 0){
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
        //println(max(avgr)+" , "+rmaxix + " , " + fftr.indexToFreq(rmaxix));
        if (avgl[lmaxix] > avgr[rmaxix]){
          strokeWeight(map((int)getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,1,4));
          myline(map((avgl[lmaxix]-avgr[lmaxix])/avgl[lmaxix],1,0,100, width/2), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvoll+avgvoll, 0,(1/sqrt(2)), width/15, width/2), getFreqIx(fftl.indexToFreq(lmaxix))%12,(int)map((fftl.indexToFreq(lmaxix)/prev),1,2,0,90),map(avgvolr, 0,0.75, 0, 255));
          prev = fftl.indexToFreq(lmaxix);
          //print("L "+fftl.indexToFreq(lmaxix)+" , "+avgvoll+" , "+(map(avgvoll, 0,1, 0, 3)+map(getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,0,4))+"\n");
        }else{
          strokeWeight(map((int)getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,1,4));
          myline(map((avgr[rmaxix]-avgl[rmaxix])/avgr[rmaxix],1,0,width-100, width/2), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvolr+avgvoll, 0,(1/sqrt(2)), width/15, width/2), getFreqIx(fftr.indexToFreq(rmaxix))%12,(int)map((fftr.indexToFreq(rmaxix)/prev),1,2,0,90),map(avgvolr, 0,0.75, 0, 255));
          prev = fftr.indexToFreq(rmaxix);
          //print("R "+fftr.indexToFreq(rmaxix)+" , "+avgvolr+" , "+(map(avgvolr, 0,1, 0, 3)+map(getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,0,4))+"\n");
        }
        /*
        if (avgl[lmaxix] > avgr[rmaxix]){
          strokeWeight(map((int)getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,1,4));
          myline(map((avgl[lmaxix]-avgr[lmaxix])/avgl[lmaxix],0,1,100, width-100), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvoll, 0,1, width/15, width/2), getFreqIx(fftl.indexToFreq(lmaxix))%12,lmaxix,map(avgvolr, 0,0.75, 0, 255));
          print(fftl.indexToFreq(lmaxix)+" , "+avgvoll+" , "+(map(avgvoll, 0,1, 0, 3)+map(getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,0,4))+"\n");
        }else{
          strokeWeight(map((int)getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,1,4));
          myline(map((avgr[rmaxix]-avgl[rmaxix])/avgr[rmaxix],0,1,100, width-100), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvolr, 0,1, width/15, width/2), getFreqIx(fftr.indexToFreq(rmaxix))%12,rmaxix,map(avgvolr, 0,0.75, 0, 255));
          print(fftr.indexToFreq(rmaxix)+" , "+avgvolr+" , "+(map(avgvolr, 0,1, 0, 3)+map(getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,0,4))+"\n");
        }
        if (avgvoll > avgvolr){
          strokeWeight(map((int)getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,1,4));
          myline(map((avgvoll-avgvolr)/avgvoll,1,0,100, width/2), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvoll, 0,1, width/15, width/2), getFreqIx(fftl.indexToFreq(lmaxix))%12,lmaxix,map(avgvolr, 0,0.75, 0, 255));
          print(fftl.indexToFreq(lmaxix)+" , "+avgvoll+" , "+(map(avgvoll, 0,1, 0, 3)+map(getFreqIx(fftl.indexToFreq(lmaxix))/12,5,0,0,4))+"\n");
        }else{
          strokeWeight(map((int)getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,1,4));
          myline(map((avgvolr-avgvoll)/avgvolr,1,0,width-100, width/2), map(player.position(),0,player.length(),100,height-100),
          (int)map(avgvolr, 0,1, width/15, width/2), getFreqIx(fftr.indexToFreq(rmaxix))%12,rmaxix,map(avgvolr, 0,0.75, 0, 255));
          print(fftr.indexToFreq(rmaxix)+" , "+avgvolr+" , "+(map(avgvolr, 0,1, 0, 3)+map(getFreqIx(fftr.indexToFreq(rmaxix))/12,5,0,0,4))+"\n");
        }
        */
        avgr = new float [fftr.specSize()];
        avgl = new float [fftl.specSize()];
        avgvolr = 0f;
        avgvoll = 0f;
      }else{
        for (int i=0;i<avgr.length;i++){
          avgr[i] += fftr.getBand(i)/winsize;
          avgl[i] += fftl.getBand(i)/winsize;
        }
        avgvolr += player.right.level()/winsize;
        avgvoll += player.left.level()/winsize;
      }
      counter++;
      if (player.position() >= player.length()&&!fin){
        fin = true;
        selectFolder("Select a folder to write to:", "fileSelectedOut");
      }
      if (exit)
        exit();
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
}
static String stripExtension (String str) {
    // Handle null case specially.

    if (str == null) return null;

    // Get position of last '.'.

    int pos = str.lastIndexOf(".");

    // If there wasn't any '.' just return the string as is.

    if (pos == -1) return str;

    // Otherwise return the string, up to the dot.

    return str.substring(0, pos);
}
  public int getFreqIx(float frequency){
    float minDiff = Float.MAX_VALUE;
    int minIndex = 0;
    for (int i = 0 ; i < frequencies.length; i ++)
    {
      float diff = Math.abs(frequencies[i] - frequency);
      if (diff < minDiff)
      {
        minDiff = diff;
        minIndex = i;
      }
    }
    return minIndex;
  }
   public void myline(float centerx, float centery, int radius, int colour, int angle, float weight){
      stroke(colours[colour],weight);
      PVector center = new PVector(centerx, centery);
      float x = center.x + cos(radians(angle))*radius/2;
      float y = center.y + sin(radians(angle))*radius/2;
      line(center.x, center.y, x, y);
      x = center.x + cos(radians(angle+180))*radius/2;
      y = center.y + sin(radians(angle+180))*radius/2;
      line(center.x, center.y, x, y);
  }
