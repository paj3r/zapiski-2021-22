package cbsp;

import javax.sound.midi.MidiUnavailableException;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

public class MIDIStreamer extends Thread {

    protected int receiverPort;
    protected int transmitterPort;
    protected String recieverAddress;
    protected DatagramSocket tsocket;
    protected byte[] sndBuffer;
    protected DatagramPacket packet;
    protected ByteArrayOutputStream bos;
    protected ObjectOutputStream out;

    private int magicNum;

    public MIDIStreamer(String recieverAddress, int receiverPort, int transmitterPort, int magicNum) {
        this.receiverPort=receiverPort;
        this.transmitterPort=transmitterPort;
        this.recieverAddress=recieverAddress;
        this.magicNum=magicNum;

        try {
            tsocket = new DatagramSocket(transmitterPort);
        } catch (SocketException ex) {
            ex.printStackTrace();
        }
    }

    public void snd() {
        System.out.println("TRANSMITTER: START");

        // TASK 7

        // For each Note repeat:

        // 	Create ByteArrayOutputStream.

        // 	Create ObjectOutputStream.

        // 	Write Note to ObjectOutputStream.

        // 	Serialize the object into byte[].

        // 	Create the DatagramPacket.

        // 	Send the DatagramPacket over the tsocket.

        System.out.println("TRANSMITTER: END");
    }

    @Override
    public void run() {
        this.snd();
    }

    public static void main(String[] args) throws MidiUnavailableException {

        int DEFAULT_TRANSMITTER_PORT = 3400;
        int DEFAULT_RECEIVER_PORT = 3300;
        String DEFAULT_RECEIVER_ADDRESS = "127.0.0.1";

        MIDIStreamPlayer mssp1 = new MIDIStreamPlayer(0, 1, DEFAULT_RECEIVER_PORT);
        MIDIStreamPlayer mssp2 = new MIDIStreamPlayer(1, 25, DEFAULT_RECEIVER_PORT+1);
        MIDIStreamer ms1 = new MIDIStreamer(DEFAULT_RECEIVER_ADDRESS, DEFAULT_RECEIVER_PORT, DEFAULT_TRANSMITTER_PORT, 10);
        MIDIStreamer ms2 = new MIDIStreamer(DEFAULT_RECEIVER_ADDRESS, DEFAULT_RECEIVER_PORT+1, DEFAULT_TRANSMITTER_PORT+1, 80);

        mssp1.start();
        mssp2.start();
        ms1.start();
        ms2.start();
    }
}
