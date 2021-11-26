package cbsp;

import java.io.IOException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.SynchronousQueue;
import javax.sound.midi.MidiChannel;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.MidiUnavailableException;
import javax.sound.midi.Synthesizer;

public abstract class MIDIPlayer extends Thread {

    protected Synthesizer synthesizer;
    protected MidiChannel channel;
    protected static BlockingQueue<Note> buffer;

    MIDIPlayer(int playerChannel, int playerProgram) throws MidiUnavailableException {

        // TASK 1, 2

        // Create blocking buffer.
        buffer = new SynchronousQueue<Note>();

        // Create MIDI Synthesizer
        synthesizer = MidiSystem.getSynthesizer();
        synthesizer.open();

        // Set the current MIDI channel.
        channel = synthesizer.getChannels()[playerChannel];

        // Set the current MIDI instrument.
        channel.programChange(playerProgram);
    }

    public abstract void rcv() throws IOException;

    public void run() {

        Note t = null;

        System.out.println("PLAYER: START");

        try {
            this.rcv();
        } catch (IOException e) {
            e.printStackTrace();
        }

        while (true) {

            // TASK 1, 2

            // Get the latest Note from the buffer.
            // Play the Note.
            Note n;
            try {
                n = buffer.take();
                channel.noteOn(n.pitch, n.velocity);
                Thread.sleep(n.duration);
                channel.noteOff(n.pitch, n.velocity);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
