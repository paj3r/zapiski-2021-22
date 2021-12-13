package cbsp;

import processing.core.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

public class SoundVisualization extends PApplet
{
    Minim minim;
    AudioPlayer player;

    @Override
    public void settings() {
        size(320, 170);
    }

    @Override
    public void setup() {
        smooth();

        minim = new Minim(this);
        player = minim.loadFile("src/main/media/Phlex - Take Me Home Tonight (feat. Caitlin Gare) [Argofox].mp3");
        player.play();
        background(0);
        int level = 0;
    }

    @Override
    public void draw() {
        /* TASKS 1-4
        float h1 = (float)height/(float)2;
        // TODO Task 1-7
        background(0);
        stroke(255);
        strokeWeight(map(player.mix.level(),0,1,10,35));
        point(map(player.position(),0,player.length(),0,width),h1);
        // You can use predefined variables such as:
        //	width: screen width,
        //  height: screen height,
        //  mouseX: x coordinate of current mouse cursor,
        //  mouseY: y coordinate of current mouse cursor...

        // For handling the keyboard and mouse input, just
        // define new public void methods with the name
        // keyPressed(), mousePressed()...
         */
        /* TASK 6
        stroke(204, 50, 0);
        strokeWeight(map(player.mix.level(),0,1,7,36));
        point(map(player.position()*7%(player.length()),0,player.length(),0,width),
                map(player.position()*7/(player.length()),0,7,0,height));
        stroke(102, 204, 0);
        strokeWeight(map(player.mix.level(),0,1,6,35));
        point(map(player.position()*7%(player.length()),0,player.length(),0,width),
                map(player.position()*7/(player.length()),0,7,0,height));
        */




    }
    public void keyPressed() {
        if (player.isPlaying()){
            player.pause();
        }else{
            player.play();
        }
    }
    public void mousePressed(){
        player.play((int) map(mouseX, 0,width,0,player.length()));
    }

    public static void main (String... args) {
        SoundVisualization pt = new SoundVisualization();
        PApplet.runSketch(new String[]{"SoundVisualization"}, pt);
    }
}

