package cbsp;

import javax.sound.midi.MidiUnavailableException;

public class MIDIDummyPlayer extends MIDIPlayer {

    MIDIDummyPlayer(int playerChannel, int playerProgram) throws MidiUnavailableException {

        super(playerChannel, playerProgram);

    }

    @Override
    public synchronized void rcv() {

        System.out.println("RECEIVER DUMMY: START");

        System.out.println("RECEIVER DUMMY: END");

    }

    public static void main(String[] args) throws MidiUnavailableException, InterruptedException {

        MIDIDummyPlayer mp = new MIDIDummyPlayer(0, 1);

        System.out.println("TRANSMITTER: START");

        // TASK 3

        // Write Notes into shared memory, you can use example from previous exercises.
        Note n = buffer.take();
        buffer.put(n);

        System.out.println("TRANSMITTER: END");

        mp.start();
    }
}