package cbsp;

import javax.sound.sampled.*;
import java.io.File;
import java.io.IOException;

public class AudioFilePlayer {
    
    public void play(String fileName) {
    	
    	// TASK 1
    	File inputfile = new File (fileName);
    	// Initialize File object.
        AudioInputStream ais = null;
    	// Declare AudioInputStream object.
        Clip clip = null;
    	// Declare Clip object
        try {
            ais = AudioSystem.getAudioInputStream(inputfile);
        } catch (UnsupportedAudioFileException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Get AudioInputStream from AudioSystem.
    	DataLine.Info info = new DataLine.Info(Clip.class,ais.getFormat());
    	// Get DataLine.Info.
        try {
            clip = (Clip) AudioSystem.getLine(info);
            clip.open(ais);
            clip.start();
        } catch (LineUnavailableException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Get current Clip Object and open it.

    	// Start the playing of the Clip object.
        try {
            Thread.sleep(clip.getMicrosecondLength()/1000 + 100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        // Wait for the end of the recording.
        
    }
    
    public static void main(String[] args) throws InterruptedException, UnsupportedAudioFileException, IOException, LineUnavailableException {
        
        String orgFilename="src/main/media/tada.wav";
        //String orgFilename="src/main/media/pcm16/pcm stereo 16 bit 48kHz.wav";
        //String orgFilename="src/main/media/pcm16/pcm mono 16 bit 48kHz.wav";
        //String orgFilename="src/main/media/pcm8/pcm stereo 8 bit 48kHz.wav";
        //String orgFilename="src/main/media/pcm8/pcm mono 8 bit 48kHz.wav";
        //String orgFilename="src/main/media/noise/Brown_Noise.wav";
        
        AudioFilePlayer afp = new AudioFilePlayer();
        System.out.println("Playing the original sound recording.");
        afp.play(orgFilename);
    }
    
}
