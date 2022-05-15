using MathNet.Numerics.LinearAlgebra;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>
    /// Example implementation of a Sampled spectrum
    /// </summary>
    public partial class SampledSpectrum : Spectrum
    {
        static int sampledLambdaStart = 400;
        static int sampledLambdaEnd = 700;
        static int nSpectralSamples = 60;
        static SampledSpectrum X, Y, Z;


        public SampledSpectrum()
        { }
        public SampledSpectrum(double cValue)
        {
            c = Vector<double>.Build.Dense(nSpectralSamples);
            c = c + cValue;
            for (int i = 0; i < nSpectralSamples; i++) {
                double wl0 = Lerp(i / nSpectralSamples,
                            sampledLambdaStart, sampledLambdaEnd);
                X.c[i] = xFit_1931(wl0);
                Y.c[i] = yFit_1931(wl0);
                Z.c[i] = zFit_1931(wl0);

            }
        }
        private SampledSpectrum(Vector<double> v) : base(v)
        {

        }
        public Vector<double> ToXYZ(){
            Vector<double> xyz = Vector<double>.Build.Dense(3);
            xyz[0] = xyz[1] = xyz[2] = 0.0;
            for (int i = 0; i<nSpectralSamples; ++i) {  
                xyz[0] += X.c[i] * c[i];
                xyz[1] += Y.c[i] * c[i];
                xyz[2] += Z.c[i] * c[i];
            }
            double scale = (double)(sampledLambdaEnd - sampledLambdaStart) / 1;
            //(double)(CIE_Y_integral * nSpectralSamples);
            xyz[0] *= scale;
            xyz[1] *= scale;
            xyz[2] *= scale;
            return xyz;
        }

        public double y(){ 
            double yy = 0.0;
            for (int i = 0; i<nSpectralSamples; ++i)
                yy += Y.c[i] * c[i];
            return yy* (double)(sampledLambdaEnd - sampledLambdaStart) / (double)(nSpectralSamples);
        }



    public override Spectrum FromSampled(Vector<double> lambda, Vector<double> v, int n)
        {
            SampledSpectrum r = new SampledSpectrum(0.0);
            for (int i = 0; i < nSpectralSamples; ++i)
            {
                double lambda0 = Lerp((double)i / (double)nSpectralSamples,
                                sampledLambdaStart, sampledLambdaEnd);
                double lambda1 = Lerp((double)(i + 1) / (double)nSpectralSamples,
                                     sampledLambdaStart, sampledLambdaEnd);
                r.c[i] = AverageSpectrumSamples(lambda, v, n, lambda0, lambda1);
            }
            return r;
        }
        double xFit_1931(double wave)
        {
            double t1 = (wave - 442.0f) * ((wave < 442.0f) ? 0.0624f : 0.0374f);
            double t2 = (wave - 599.8f) * ((wave < 599.8f) ? 0.0264f : 0.0323f);
            double t3 = (wave - 501.1f) * ((wave < 501.1f) ? 0.0490f : 0.0382f);
            return 0.362f * Math.Exp(-0.5f * t1 * t1) + 1.056f * Math.Exp(-0.5f * t2 * t2)
            - 0.065f * Math.Exp(-0.5f * t3 * t3);
        }
        double yFit_1931(double wave)
        {
            double t1 = (wave - 568.8f) * ((wave < 568.8f) ? 0.0213f : 0.0247f);
            double t2 = (wave - 530.9f) * ((wave < 530.9f) ? 0.0613f : 0.0322f);
            return 0.821f * Math.Exp(-0.5f * t1 * t1) + 0.286f * Math.Exp(-0.5f * t2 * t2);
        }
        double zFit_1931(double wave)
        {
            double t1 = (wave - 437.0f) * ((wave < 437.0f) ? 0.0845f : 0.0278f);
            double t2 = (wave - 459.0f) * ((wave < 459.0f) ? 0.0385f : 0.0725f);
            return 1.217f * Math.Exp(-0.5f * t1 * t1) + 0.681f * Math.Exp(-0.5f * t2 * t2);
        }


        public override Spectrum FromRGB(Color c)
        {
            throw new NotImplementedException();
        }

        public override double[] ToRGB()
        {
            throw new NotImplementedException();
        }
    }
}
