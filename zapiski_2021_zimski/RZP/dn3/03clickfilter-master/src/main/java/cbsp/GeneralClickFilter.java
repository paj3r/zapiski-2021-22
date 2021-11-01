package cbsp;

import java.util.BitSet;

public class GeneralClickFilter extends ClickFilterBase {
	public static void main(String args[]) {
		new GeneralClickFilter().run();
	}
	//Standardna deviacija in povpprečje
	/**
	 * Performs sample processing.
	 * 
	 * @param samples
	 *            A mutable array of float samples
	 */
	@Override
	protected void process(float[] samples) {
		final int BIG_WINDOW_SIZE = 2048;
		final int SMALL_WINDOW_SIZE = 20;
		for(int i = 0; i < samples.length-2048; i++){
			float small_avg = 0;
			float big_avg = 0;
			for(int j =0;j<SMALL_WINDOW_SIZE;j++){
				small_avg += Math.abs(samples[i+j+1014]);
			}
			small_avg = small_avg/20;
			for(int j = 0; j<BIG_WINDOW_SIZE; j++){
				big_avg += Math.abs(samples[i+j]);
			}
			big_avg = big_avg/2048;

			if (small_avg*0.3>big_avg){
				float start = samples[i+1014];
				float end = samples[i+1034];
				float diff = (end-start)/20;
				for(int j = 0;j<20;j++){
					samples[i+j+1014] = start+(diff*j);
				}
			}

		}
		// TODO General click filter.
		
	}
}
