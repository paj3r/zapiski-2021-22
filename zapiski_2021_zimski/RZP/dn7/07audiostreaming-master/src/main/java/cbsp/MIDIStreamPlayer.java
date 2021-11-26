package cbsp;

import javax.sound.midi.MidiUnavailableException;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.SocketException;
import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

public class MIDIStreamPlayer extends MIDIPlayer implements Callable {

    protected int playerChannel;
    protected int playerProgram;

    protected int receiverPort;
    protected DatagramSocket rsocket;
    protected byte[] rcvBuffer;
    protected DatagramPacket packet;

    protected ByteArrayInputStream bis;
    protected ObjectInputStream in;

    public MIDIStreamPlayer(int playerChannel, int playerProgram, int receiverPort) throws MidiUnavailableException {

        super(playerChannel, playerProgram);

        this.playerChannel = playerChannel;
        this.playerProgram = playerProgram;
        this.receiverPort=receiverPort;
        try {
            this.rsocket = new DatagramSocket(receiverPort);	// Create a Datagram socket.
        } catch (SocketException ex) {
            ex.printStackTrace();
        }
        this.rcvBuffer=new byte[1024];		// Create buffer.
    }

    @Override
    public synchronized void rcv() {
        new WorkerThread(this).start();
    }

    public synchronized void callback() throws IOException {
        System.out.println("RECEIVER ST: START");
        // TASK 6
        packet = new DatagramPacket(rcvBuffer, rcvBuffer.length);

        // Wait for new packet.
        try {
            rsocket.receive(packet);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Extract the byte[] buffer.
        // Write current Note into buffer.
        byte [] buffer = packet.getData();

        // Deserialize the note object.
        bis = new ByteArrayInputStream(buffer);
        in = new ObjectInputStream(bis);
        Note n;
        try {
            n = (Note) in.readObject();
            this.buffer.put(n);
        } catch (ClassNotFoundException | InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("RECEIVER ST: END");
    }

    public static void main(String[] args) throws MidiUnavailableException {

        int DEFAULT_TRANSMITTER_PORT = 3400;
        int DEFAULT_RECEIVER_PORT = 3300;
        String DEFAULT_RECEIVER_ADDRESS = "127.0.0.1";

        MIDIStreamPlayer msp = new MIDIStreamPlayer(0, 1, DEFAULT_RECEIVER_PORT);
        msp.start();

        try {
            Thread.sleep(4000);
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }

        System.out.println("TRANSMITTER: START");
        DatagramSocket tsocket = null;
        try {
            tsocket = new DatagramSocket(DEFAULT_TRANSMITTER_PORT);		// Open the socket on chosen IP and port.
        } catch (SocketException ex) {
            ex.printStackTrace();
        }

        // TASK 6
        while(true){
            try {
                Note n = buffer.take();
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                ObjectOutputStream out = new ObjectOutputStream(bos);
                out.writeObject(n);
                out.flush();
                byte[] bytes = bos.toByteArray();
                bos.close();
                out.close();
                DatagramPacket pac = new DatagramPacket(bytes, bytes.length);
                assert tsocket != null;
                tsocket.send(pac);
            } catch (InterruptedException | IOException e) {
                e.printStackTrace();
                break;
            }
        }

        System.out.println("TRANSMITTER: END");

    }
}

