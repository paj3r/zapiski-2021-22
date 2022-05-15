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

        public double AverageSpectrumSamples(Vector<double> lambda, Vector<double> vals,
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
        public abstract Spectrum FromRGB(Color c);

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
        public static Spectrum CreateSpectral(double cValue)
        {
            return new SampledSpectrum(cValue);
        }


    }
}
