package cbsp;

import com.jsyn.JSyn;
import com.jsyn.Synthesizer;
import com.jsyn.unitgen.*;

public class SoundGeneratorB {
	
	// Graph components.
	private Synthesizer synth;
	private LineOut lineOut;
	private Add adder;
	private Add adder2;
	private Add adder3;
	private Add adder4;
	private Add adder5;
	private Add adder6;
	private Add adder7;

	public static void main(String args[]) {
		new SoundGeneratorB().start();
	}

	private void start() {

		synth = JSyn.createSynthesizer();					// Initialization of JSyn API

		synth.add(lineOut = new LineOut());					// Create line out and add it to the graph.
		synth.start();



		// TODO Task 2.
		/* TASK A
		int seconds = 4;															// Duration of our signal.
		int frequency = 1908;
		int amplitude = 51;
		SineOscillator syn = new SineOscillator();
		synth.add(syn);

		syn.output.connect(0, lineOut.input, 0);
		syn.output.connect(0, lineOut.input, 1);

		syn.frequency.set(frequency);
		syn.amplitude.set(amplitude);

		lineOut.start();									// Start the data flow in graph.

		// Play signal for 2 seconds.
		try {
			synth.sleepFor(seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		synth.stop();	 									// Turn off JSyn engine
		 */
		/* TASK B
		int seconds = 4;															// Duration of our signal.
		int frequency1 = 1131;
		int amplitude1 = 65;
		int frequency2 = 633;
		int amplitude2 = 92;
		SineOscillator syn1 = new SineOscillator();
		synth.add(syn1);
		SineOscillator syn2 = new SineOscillator();
		synth.add(syn2);

		syn1.frequency.set(frequency1);
		syn1.amplitude.set(amplitude1);

		syn2.frequency.set(frequency2);
		syn2.amplitude.set(amplitude2);

		synth.add(adder = new Add());
		syn1.output.connect(adder.inputB);
		adder.inputA.connect(syn2.output);
		adder.output.connect(0, lineOut.input, 0);
		adder.output.connect(0, lineOut.input, 1);

		lineOut.start();									// Start the data flow in graph.


		try {
			synth.sleepFor(seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		synth.stop();	 									// Turn off JSyn engine

		 */
		//POGLEDAT KAJ JE PASSTHROUGH

		int seconds = 4;															// Duration of our signal.
		int frequency = 339;
		int amplitude = 115;
		double[] harm = new double[7];
		harm[0] = 0.92; harm[1] = 0.81; harm[2] = 0.97; harm[3] = 0.99; harm[4] = 0.95;
		harm[5] = 0.75; harm[6] = 0.49;
		SineOscillator syn1 = new SineOscillator();
		SineOscillator syn2 = new SineOscillator();
		SineOscillator syn3 = new SineOscillator();
		SineOscillator syn4 = new SineOscillator();
		SineOscillator syn5 = new SineOscillator();
		SineOscillator syn6 = new SineOscillator();
		SineOscillator syn7 = new SineOscillator();
		SineOscillator syn8 = new SineOscillator();

		synth.add(syn1);
		synth.add(syn2);
		synth.add(syn3);
		synth.add(syn4);
		synth.add(syn5);
		synth.add(syn6);
		synth.add(syn7);
		synth.add(syn8);


		syn1.frequency.set(frequency);
		syn1.amplitude.set(amplitude);

		syn2.frequency.set(frequency*2);
		syn2.amplitude.set(amplitude*harm[0]);

		syn3.frequency.set(frequency*3);
		syn3.amplitude.set(amplitude*harm[1]);

		syn4.frequency.set(frequency*4);
		syn4.amplitude.set(amplitude*harm[2]);

		syn5.frequency.set(frequency*5);
		syn5.amplitude.set(amplitude*harm[3]);

		syn6.frequency.set(frequency*6);
		syn6.amplitude.set(amplitude*harm[4]);

		syn7.frequency.set(frequency*7);
		syn7.amplitude.set(amplitude*harm[5]);

		syn8.frequency.set(frequency*8);
		syn8.amplitude.set(amplitude*harm[6]);

		synth.add(adder = new Add());
		synth.add(adder2 = new Add());
		synth.add(adder3 = new Add());
		synth.add(adder4 = new Add());
		synth.add(adder5 = new Add());
		synth.add(adder6 = new Add());
		synth.add(adder7 = new Add());

		syn1.output.connect(adder.inputB);
		syn2.output.connect(adder.inputA);
		adder.output.connect(0, adder2.inputA, 0);
		syn3.output.connect(adder2.inputB);
		adder2.output.connect(0, adder3.inputA, 0);
		syn4.output.connect(adder3.inputB);
		adder3.output.connect(0, adder4.inputA, 0);
		syn5.output.connect(adder4.inputB);
		adder4.output.connect(0, adder5.inputA, 0);
		syn6.output.connect(adder5.inputB);
		adder5.output.connect(0, adder6.inputA, 0);
		syn7.output.connect(adder6.inputB);
		adder6.output.connect(0, adder7.inputA, 0);
		syn8.output.connect(adder7.inputB);
		adder7.output.connect(0, lineOut.input, 0);
		adder7.output.connect(0, lineOut.input, 1);



		lineOut.start();									// Start the data flow in graph.


		try {
			synth.sleepFor(seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		synth.stop();	 									// Turn off JSyn engine

	}
}