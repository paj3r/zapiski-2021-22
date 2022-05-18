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
    /// Base general spectrum class implementation. Spectrum can be implemented as RGB, XYZ, discrete spectrum of light frequencies ...
    /// </summary>
    public abstract partial class Spectrum
    {
        public Vector<double> c;
        public int nSamples;
        public enum SpectrumType { Reflectance, Illuminant };

        public static Spectrum ZeroSpectrum => Spectrum.Create(0);

        public Spectrum()
        { }
        protected Spectrum(Vector<double> v)
        {
            c = v;
        }

        /// <summary>
        /// Currently, generate am RGB implementation. If other implementations are added, change this
        /// </summary>
        /// <param name="cValue"></param>
        /// <returns></returns>
        /// 
        public static Spectrum Create(double cValue)
        {
            return new SpectrumRGB(cValue);
        }
        public static Spectrum Create(Vector<double> v)
        {
            var s = Create(0);
            s.c = v;
            return s;
        }

        public bool IsBlack()
        {
            return c.All(x => x < Renderer.Epsilon);
        }


        public Spectrum AddTo(Spectrum v2)
        {
            c += v2.c;
            return this;
        }

        public static Spectrum operator +(Spectrum v1, Spectrum v2)
        {
            v1.c += v2.c;
            return v1;
        }
        public static Spectrum operator *(Spectrum v1, Spectrum v2)
        {
            Spectrum t = (Spectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c.PointwiseMultiply(v2.c);
            return t;
        }

        public static Spectrum operator -(Spectrum v1, Spectrum v2)
        {
            Spectrum t = (Spectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c - v2.c;
            return t;
        }

        public static Spectrum operator *(Spectrum v1, double v2)
        {
            Spectrum t = (Spectrum)Activator.CreateInstance(v1.GetType());
            t.c = (v1.c * v2);
            return t;
        }

        public static Spectrum operator *(double v1, Spectrum v2)
        {
            Spectrum t = (Spectrum)Activator.CreateInstance(v2.GetType());
            t.c = (v1 * v2.c);
            return t;
        }

        public static Spectrum operator /(Spectrum v1, double v2)
        {
            Spectrum t = (Spectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c / v2;
            return t;
        }
        public static Spectrum Sqrt(Spectrum s)
        {
            Spectrum ret = Spectrum.Create(Vector<double>.Build.Dense(s.c.Count));
            for (int i = 0; i < s.c.Count; ++i)
                ret.c[i] = Math.Sqrt(s.c[i]);
            return ret;
        
        }

        public double Lerp(double t, double s1,double s2) {
            return (1 - t) * s1 + t * s2;
        }

        public double AverageSpectrumSamples(double[] lambda, double[] vals,
        int n, double lambdaStart, double lambdaEnd)
        {
            if (lambdaEnd <= lambda[0]) return vals[0];
            if (lambdaStart >= lambda[n - 1]) return vals[n - 1];
            if (n == 1) return vals[0];
            double sum = 0;
            if (lambdaStart < lambda[0])
                sum += vals[0] * (lambda[0] - lambdaStart);
            if (lambdaEnd > lambda[n - 1])
                sum += vals[n - 1] * (lambdaEnd - lambda[n - 1]);
            int k = 0;
            while (lambdaStart > lambda[k + 1]) ++k;
            double interp (double w, int i) {
                return Lerp((w - lambda[i]) / (lambda[i + 1] - lambda[i]),
                            vals[i], vals[i + 1]);
            };
            for (; k + 1 < n && lambdaEnd >= lambda[k]; ++k)
            {
                double segLambdaStart = Math.Max(lambdaStart, lambda[k]);
                double segLambdaEnd = Math.Min(lambdaEnd, lambda[k + 1]);
                sum += 0.5 * (interp(segLambdaStart, k) + interp(segLambdaEnd, k)) *
                    (segLambdaEnd - segLambdaStart);
            }
            return sum / (lambdaEnd - lambdaStart);
        }

        public double Max()
        {
            return c.Max();
        }
        public abstract double[] ToRGB();
        public abstract Spectrum FromRGB(Color c, SpectrumType type);

        public abstract Spectrum FromXYZ(Vector<double> rgb, SpectrumType type);

        public abstract Spectrum FromSampled(Vector<double> lambda, Vector<double> v, int n);


    public Spectrum Clamp()
        {
            for (int i = 0; i < c.Count; i++)
            {
                if (c[i] < 0)
                    c[i] = 0;
            }
            return this;
        }
        public static SampledSpectrum CreateSpectral(double cValue)
        {
            return new SampledSpectrum(cValue);
        }
        public static SampledSpectrum CreateSpectral(Vector<double> v)
        {
            var s = CreateSpectral(0);
            s.c = v;
            return s;
        }

        public static Spectrum createSpectralUni() {
            var s = CreateSpectral(0);
            var ou = s.createUniorm();
            return ou;
        }

        public static Spectrum createSpectralMag()
        {
            var s = CreateSpectral(0);
            var ou = s.createMagenta();
            return ou;
        }

        public Vector<double> XYZToRGB(Vector<double> xyz) {
            Vector<double> rgb = Vector<double>.Build.Dense(3);
            rgb[0] =  3.240479*xyz[0] - 1.537150*xyz[1] - 0.498535*xyz[2];
            rgb[1] = -0.969256*xyz[0] + 1.875991*xyz[1] + 0.041556*xyz[2];
            rgb[2] =  0.055648*xyz[0] - 0.204043*xyz[1] + 1.057311*xyz[2];
            for (int i = 0; i < 3; i++)
            {
                if (rgb[i] > .0031308f)
                {
                    rgb[i] = (1.055f * (float)Math.Pow(rgb[i], (1.0f / 2.4f))) - .055f;
                }
                else
                {
                    rgb[i] = rgb[i] * 12.92f;
                }
            }
            for (int i = 0; i < 3; i++)
            {
                if (rgb[i] > 1)
                {
                    rgb = rgb / rgb[i];
                }
                if(rgb[i] < 0)
                    rgb[i] = 0;
            }  
            return rgb;
        }

        public Vector<double> RGBToXYZ(Vector<double> rgb) {
            Vector<double> xyz = Vector<double>.Build.Dense(3);
            xyz[0] = 0.412453f*rgb[0] + 0.357580f*rgb[1] + 0.180423f*rgb[2];
            xyz[1] = 0.212671f*rgb[0] + 0.715160f*rgb[1] + 0.072169f*rgb[2];
            xyz[2] = 0.019334f*rgb[0] + 0.119193f*rgb[1] + 0.950227f*rgb[2];
            return xyz;
        }



    }
}
