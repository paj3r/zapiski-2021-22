package cbsp;

import javax.sound.midi.MidiUnavailableException;
import java.io.*;

public class MIDIFileSimplePlayer extends MIDIPlayer {

    protected String filename;
    protected FileInputStream fis;
    protected ObjectInputStream in;

    public MIDIFileSimplePlayer(int playerChannel, int playerProgram, String filename) throws MidiUnavailableException {

        super(playerChannel, playerProgram);
        this.filename = filename;

    }

    @Override
    public synchronized void rcv() throws IOException {

        System.out.println("RECEIVER FS: START");

        // TASK 4

        // Open the input FileInputStream.
        try {
            fis = new FileInputStream(filename);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        // Deserialize the input stream with ObjectInputStream.
        try {
            in = new ObjectInputStream(fis);
        } catch (IOException e) {
            e.printStackTrace();
        }


        // Write Notes from file to buffer.

        for(int i = 0;i<in.readInt();i++){
            try {
                buffer.put((Note) in.readObject());
            } catch (ClassNotFoundException | InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("RECEIVER FS: END");
    }

    public static void main(String[] args) throws MidiUnavailableException {

        FileOutputStream fos = null;
        ObjectOutputStream out = null;

        MIDIFileSimplePlayer mfp = new MIDIFileSimplePlayer(0, 1, "notes.bin");

        System.out.println("TRANSMITTER: START");

        // TASK 4

        // Write Notes to a file ("notes.bin").
        try {
            fos = new FileOutputStream("notes.bin");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        try {
            out = new ObjectOutputStream(fos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        while(true){
            try {
                Note n = buffer.take();
                if (n.pitch == null)
                    break;
                assert out != null;
                out.writeObject(n);
            } catch (IOException | InterruptedException e) {
                e.printStackTrace();
                break;
            }
        }


        System.out.println("TRANSMITTER: END");

        mfp.start();	// Start MIDIFileSimplePlayer
    }

}

