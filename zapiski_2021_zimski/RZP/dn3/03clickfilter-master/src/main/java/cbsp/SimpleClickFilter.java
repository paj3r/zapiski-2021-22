package cbsp;

public class SimpleClickFilter extends ClickFilterBase {
	public static void main(String args[]) {
		new SimpleClickFilter().run();
	}

	/**
	 * Performs sample processing.
	 * 
	 * @param samples
	 *            A mutable array of float samples
	 */
	@Override
	protected void process(float[] samples) {
		final float THRESHOLD = 0.0f;
		float total = 0;
		for(int i = 0; i<samples.length; i++){
			total = total + Math.abs(samples[i]);
		}
		float average = total / samples.length;
		System.out.println("avg: " + average);
		float stdDev = 0;
		for(int i = 0; i<samples.length; i++){
			stdDev += Math.pow((samples[i] - average), 2);
		}
		stdDev = (float) Math.sqrt(stdDev/samples.length);
		System.out.println("std: " + stdDev);
		for(int i = 0;i<samples.length;i++){
			if((Math.abs(samples[i])-average)>(stdDev*5)){
				for(int j =0 ;j<200;j++)
					samples[i+j]=0;
			}
		}
		// TODO Simple click filter.
		
	}
}
