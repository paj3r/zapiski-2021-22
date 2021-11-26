package cbsp;

import com.jsyn.unitgen.Add;
import com.jsyn.unitgen.SineOscillator;

public class SimpleFilters extends FiltersBase {

	SimpleFilters() {
		super();
		
		// TODO Task 1.
		FiltersBase filter = new FiltersBase() {

		};
		output = filter.output;
		Add adder;
		Add adder2;
		SineOscillator syn1 = new SineOscillator();
		SineOscillator syn2 = new SineOscillator();
		SineOscillator syn3 = new SineOscillator();
		filter.synth.add(syn1);
		filter.synth.add(syn2);
		filter.synth.add(syn3);
		syn1.frequency.set(349);
		syn1.amplitude.set(0.63);
		syn2.frequency.set(3058);
		syn2.amplitude.set(0.68);
		syn3.frequency.set(5599);
		syn3.amplitude.set(0.37);
		filter.synth.add(adder = new Add());
		filter.synth.add(adder2 = new Add());
		syn1.output.connect(adder.inputB);
		syn2.output.connect(adder.inputA);
		adder.output.connect(0, adder2.inputA, 0);
		syn3.output.connect(adder2.inputB);
		adder2.output.connect(0,filter.lineOut.input,0);
		adder2.output.connect(0,filter.lineOut.input,1);
		output = filter.output;
	}

	public static void main(String[] args) {
		new SimpleFilters().run();
	}
}
