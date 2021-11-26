package cbsp;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.SourceDataLine;

public class SoundGeneratorA {

	public static void main(String[] args) {

        /* TASK A
        int seconds = 9;															// Duration of our signal.
        int sampleRate = 34563;														// Number of samples recorded in 1 second.
        int frequency = 1458;
        int amplitude = 122;
        double harmonics = new double[0];
        */

        /* TASK B
        int seconds = 9;															// Duration of our signal.
        int sampleRate = 13740;														// Number of samples recorded in 1 second.
        int frequency = 1991;
        int amplitude = 62;
        double harmonics = new double[0];
        */

        /* TASK C

        */


        try {
            //TASK A
            int seconds = 9;															// Duration of our signal.
            int sampleRate = 34563;														// Number of samples recorded in 1 second.
            int frequency = 1458;
            int amplitude = 122;
            double[] harmonics = new double[0];
            AudioFormat af = new AudioFormat((float) sampleRate, 8,
                    1, true, true);		                // Define the format: AudioFormat(sample rate, sample size in bits, channels, signed, endian)
            DataLine.Info info = new DataLine.Info(SourceDataLine.class, af);		// Define the audio-related functionality.
            SourceDataLine source = (SourceDataLine) AudioSystem.getLine(info);		// Define a data line to which data may be written.
            source.open(af);
            source.start();

            byte[] buf = new byte[sampleRate * seconds]; 							// sampleRate * seconds = signal length

            // TODO Task 1.
            double diff = (2*Math.PI*frequency)/sampleRate;
            double pos = 0;
            for(int i = 0;i<buf.length;i++){
                buf[i] = (byte) (Math.sin(pos)*amplitude);
                pos = pos + diff;
            }
            source.write(buf, 0, buf.length);									// Write buffer to the SourceDataLine.
            source.drain();															// Play the samples in the buffer.
            source.stop();
            source.close();
            /* TASK B
            int seconds = 9;															// Duration of our signal.
            int sampleRate = 13740;														// Number of samples recorded in 1 second.
            int frequency = 1991;
            int amplitude = 62;
            double[] harmonics = new double[0];
            AudioFormat af = new AudioFormat((float) sampleRate, 8,
                    1, true, true);		                // Define the format: AudioFormat(sample rate, sample size in bits, channels, signed, endian)
            DataLine.Info info = new DataLine.Info(SourceDataLine.class, af);		// Define the audio-related functionality.
            SourceDataLine source = (SourceDataLine) AudioSystem.getLine(info);		// Define a data line to which data may be written.
            source.open(af);
            source.start();

             */
            /* TASK C
            int seconds = 4;															// Duration of our signal.
            int sampleRate = 13464;														// Number of samples recorded in 1 second.
            int frequency = 300;
            int amplitude = 15;
            double[] harmonics = new double[9];
            harmonics[0] = 0.81; harmonics[1] = 0.95; harmonics[2] = 0.86; harmonics[3] = 0.3;
            harmonics[4] = 0.76; harmonics[5] = 1.0; harmonics[6] = 0.52; harmonics[7] = 0.38;
            harmonics[8] = 0.7;
            AudioFormat af = new AudioFormat((float) sampleRate, 8,
                    1, true, true);		                // Define the format: AudioFormat(sample rate, sample size in bits, channels, signed, endian)
            DataLine.Info info = new DataLine.Info(SourceDataLine.class, af);		// Define the audio-related functionality.
            SourceDataLine source = (SourceDataLine) AudioSystem.getLine(info);		// Define a data line to which data may be written.
            source.open(af);
            source.start();

            double diff = (2*Math.PI*frequency)/sampleRate;
            double pos = 0;
            for(int i = 0;i<buf.length;i++){
                buf[i] = (byte) (Math.sin(pos)*amplitude);
                pos = pos + diff;
            }
            for(int h = 0;h<harmonics.length;h++){
                diff = (2*Math.PI*frequency*(h+1))/sampleRate;
                pos = 0;
                for(int i = 0;i<buf.length;i++){
                    buf[i] = (byte) (buf[i] + (byte) (Math.sin(pos)*amplitude*harmonics[h]));
                    pos = pos + diff;
                }
            }

            source.write(buf, 0, buf.length);									// Write buffer to the SourceDataLine.
            source.drain();															// Play the samples in the buffer.
            source.stop();
            source.close();
            */
            /* TASK D
            int seconds = 5;															// Duration of our signal.
            int sampleRate = 12321;														// Number of samples recorded in 1 second.
            int frequency = 282;
            int amplitude = 34;
            double[] harmonics = new double[3];
            harmonics[0] = 0.56; harmonics[1] = 0.7; harmonics[2] = 0.57;
            AudioFormat af = new AudioFormat((float) sampleRate, 8,
                    1, true, true);		                // Define the format: AudioFormat(sample rate, sample size in bits, channels, signed, endian)
            DataLine.Info info = new DataLine.Info(SourceDataLine.class, af);		// Define the audio-related functionality.
            SourceDataLine source = (SourceDataLine) AudioSystem.getLine(info);		// Define a data line to which data may be written.
            source.open(af);
            source.start();

            byte[] buf = new byte[sampleRate * seconds]; 							// sampleRate * seconds = signal length

            // TODO Task 1.
            double diff = (2*Math.PI*frequency)/sampleRate;
            double pos = 0;
            for(int i = 0;i<buf.length;i++){
                buf[i] = (byte) (Math.cos(pos)*amplitude);
                pos = pos + diff;
            }
            for(int h = 0;h<harmonics.length;h++){
                diff = (2*Math.PI*frequency*(h+1))/sampleRate;
                pos = 0;
                for(int i = 0;i<buf.length;i++){
                    buf[i] = (byte) (buf[i] + (byte) (Math.cos(pos)*amplitude*harmonics[h]));
                    pos = pos + diff;
                }
            }

            source.write(buf, 0, buf.length);									// Write buffer to the SourceDataLine.
            source.drain();															// Play the samples in the buffer.
            source.stop();
            source.close();
            */
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
}
