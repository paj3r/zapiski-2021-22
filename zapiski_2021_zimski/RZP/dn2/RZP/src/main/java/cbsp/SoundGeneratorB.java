package cbsp;

import com.jsyn.JSyn;
import com.jsyn.Synthesizer;
import com.jsyn.unitgen.*;

public class SoundGeneratorB {
	
	// Graph components.
	private Synthesizer synth;
	private LineOut lineOut;

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

		syn1.output.connect(0, lineOut.input, 0);
		syn1.output.connect(0, lineOut.input, 1);

		syn1.frequency.set(frequency1);
		syn1.amplitude.set(amplitude1);

		syn2.output.connect(0, lineOut.input, 0);
		syn2.output.connect(0, lineOut.input, 1);

		syn2.frequency.set(frequency2);
		syn2.amplitude.set(amplitude2);

		lineOut.start();									// Start the data flow in graph.


		try {
			synth.sleepFor(seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		synth.stop();	 									// Turn off JSyn engine

		 */
		int seconds = 4;															// Duration of our signal.
		int frequency = 339;
		int amplitude = 115;
		double[] harm = new double[7];
		harm[0] = 0.92; harm[1] = 0.81; harm[2] = 0.97; harm[3] = 0.99; harm[4] = 0.95;
		harm[5] = 0.75; harm[6] = 0.49;
		SineOscillator syn1 = new SineOscillator();
		synth.add(syn1);

		syn1.output.connect(0, lineOut.input, 0);
		syn1.output.connect(0, lineOut.input, 1);

		syn1.frequency.set(frequency);
		syn1.amplitude.set(amplitude);

		SineOscillator[] harms = new SineOscillator[7];
		for(int i = 0;i<harm.length;i++){
			harms[i] = new SineOscillator();
			synth.add(harms[i]);
			harms[i].output.connect(0, lineOut.input, 0);
			harms[i].output.connect(0, lineOut.input, 1);

			harms[i].frequency.set(frequency*(i+2));
			harms[i].amplitude.set(amplitude*harm[i]);
		}

		lineOut.start();									// Start the data flow in graph.


		try {
			synth.sleepFor(seconds);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		synth.stop();	 									// Turn off JSyn engine

	}
}