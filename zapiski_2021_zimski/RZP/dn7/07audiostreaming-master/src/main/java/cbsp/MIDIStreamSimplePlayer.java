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

public class MIDIStreamSimplePlayer extends MIDIPlayer {

    protected int receiverPort;
    protected DatagramSocket rsocket;
    protected byte[] rcvBuffer;
    protected DatagramPacket packet;

    protected ByteArrayInputStream bis;		// ByteArrayInputStream instead of FileInputStream.
    protected ObjectInputStream in;

    public MIDIStreamSimplePlayer(int playerChannel, int playerProgram, int receiverPort) throws MidiUnavailableException {

        super(playerChannel, playerProgram);

        this.receiverPort=receiverPort;
        try {
            this.rsocket = new DatagramSocket(receiverPort);	// Create a Datagram socket.
        } catch (SocketException ex) {
            ex.printStackTrace();
        }
        this.rcvBuffer=new byte[1024];		// Create buffer.
    }

    @Override
    public synchronized void rcv() throws IOException {

        System.out.println("RECEIVER ST: START");

        // TASK 5

        // Create Datagram packet.
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
            this.buffer.add(n);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        System.out.println("RECEIVER ST: END");
    }

    public void main(String[] args) throws MidiUnavailableException {

        int DEFAULT_TRANSMITTER_PORT = 3334;
        int DEFAULT_RECEIVER_PORT = 3333;
        String DEFAULT_RECEIVER_ADDRESS = "127.0.0.1";

        MIDIStreamSimplePlayer mssp = new MIDIStreamSimplePlayer(0, 1, DEFAULT_RECEIVER_PORT);

        System.out.println("TRANSMITTER: START");
        DatagramSocket tsocket = null;
        try {
            tsocket = new DatagramSocket(DEFAULT_TRANSMITTER_PORT);		// Open the socket on chosen IP and port.
        } catch (SocketException ex) {
            ex.printStackTrace();
        }

        // TASK 5

        // For each Note repeat:
        while(true){
            try {
                Note n = this.buffer.take();
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

        mssp.start();	// Start MIDIStreamSimplePlayer.
    }
}

