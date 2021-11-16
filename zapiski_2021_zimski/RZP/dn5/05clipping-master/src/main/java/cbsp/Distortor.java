package cbsp;

import com.jsyn.data.DoubleTable;
import com.jsyn.data.Function;
import com.jsyn.ports.ConnectableInput;
import com.jsyn.ports.UnitInputPort;
import com.jsyn.ports.UnitOutputPort;
import com.jsyn.unitgen.Circuit;
import com.jsyn.unitgen.FunctionEvaluator;
import com.jsyn.unitgen.InterpolatingDelay;
import com.jsyn.unitgen.Multiply;
import com.jsyn.unitgen.PassThrough;
import com.jsyn.unitgen.UnitSource;
import com.softsynth.shared.time.TimeStamp;

public class Distortor extends Circuit implements UnitSource {
	// Ports
	public final UnitInputPort input;
	public final UnitOutputPort output;
	public final UnitOutputPort feedback;

	// Circuit components
	protected Multiply masterIn;
	protected DoubleTable waveShape;
	protected FunctionEvaluator waveShaper;
	protected Multiply outputGain;
	protected InterpolatingDelay delay;

	Distortor() {
		// TODO Task 2.

		// The code below is just so the default (null) distortor doesn't crash
		// the application - it should be removed
		double[] tab = {-0.8, -0.8, -0.8, -0.6, -0.2, 0.0, 0.2, 0.6, 0.8, 0.8, 0.8};
		waveShape = new DoubleTable(tab);
		add(masterIn = new Multiply());
		input = masterIn.inputB;
		add(waveShaper = new FunctionEvaluator());
		waveShaper.function.set(waveShape);
		waveShaper.input.connect(masterIn.output);
		output = waveShaper.output;
		add(outputGain = new Multiply());
		outputGain.inputB.connect(waveShaper.output);
		add(delay = new InterpolatingDelay());
		delay.input.connect(outputGain.output);
		delay.allocate(1);
		delay.delay.set(0.001);
		feedback = delay.output;
	}

	@Override
	public UnitOutputPort getOutput() {
		return output;
	}

	public void distort(TimeStamp start, double amp, double dgain, double fbfreq, double fbgain) {
		masterIn.inputA.set(dgain / amp, start);
        waveShaper.amplitude.set(amp, start);
        delay.delay.set(1.0 / fbfreq, start);
        outputGain.inputA.set(fbgain, start);
	}
}
