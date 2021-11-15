package cbsp;

import javax.sound.midi.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class MIDIsynthesizer {
	
	// TODO Create classes for MIDI messages for Task 4 in 6.
	protected MidiMessage createMIDINoteOnMessage(int note, int velocity) throws InvalidMidiDataException {
		return new ShortMessage(ShortMessage.NOTE_ON,note,velocity);
	}
	protected MidiMessage createMIDINoteOffMessage(int note, int velocity) throws InvalidMidiDataException {
		return new ShortMessage(ShortMessage.NOTE_OFF, note, velocity);
	}
	protected MidiMessage createMidiMessage(int command,int channel, int data1, int data2) throws InvalidMidiDataException {
		return new ShortMessage(command,channel,data1,data2);
	}
	
	public MIDIsynthesizer() {

		try {
			Synthesizer syn = MidiSystem.getSynthesizer();
			syn.open();
			Receiver rec = syn.getReceiver();

			/* TASK 4
			rec.send(createMIDINoteOnMessage(60,90),0);
			Thread.sleep(2000);
			rec.send(createMIDINoteOffMessage(60,90),0);*/
			int[]durations = {250,250,250,250,250,250,500,250,250,250,250,500};
			int[]notes = {65,65,65,60,62,62,60,69,69,67,67,65};
			/*TASK 6
			rec.send(createMidiMessage(ShortMessage.PROGRAM_CHANGE,0,41,0),0);

			for(int i=0;i<12;i++){
				rec.send(createMIDINoteOnMessage(notes[i],90),0);
				Thread.sleep(durations[i]);
				rec.send(createMIDINoteOffMessage(notes[i],90),0);
			}*/
			MidiChannel channel0 = syn.getChannels()[0];
			MidiChannel channel1 = syn.getChannels()[1];
			channel1.programChange(74);
			if (channel0!=null){
				for(int i=0;i<12;i++){
					channel0.noteOn(notes[i],90);
					channel1.noteOn(notes[i]+12,60);
					Thread.sleep(durations[i]);
					channel0.noteOff(notes[i]);
					channel1.noteOff(notes[i]+12);
				}
			}
		} catch (MidiUnavailableException | InterruptedException e) {
			e.printStackTrace();
		}


		// TODO Task 1 - 9. Be mindful of handling exceptions.

	}

	public static void main(String[] args) {
		
		MIDIsynthesizer synthesizer = new MIDIsynthesizer();
			
	}

}
