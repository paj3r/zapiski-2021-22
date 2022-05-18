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
    /// Example implementation of an RGB spectrum
    /// </summary>
    public partial class SpectrumRGB : Spectrum
    {

        public SpectrumRGB()
        { }
        public SpectrumRGB(double cValue)
        {
            c = Vector<double>.Build.Dense(3);
            c = c + cValue;
        }
        private SpectrumRGB(Vector<double> v) : base(v)
        {
        }

        public override double[] ToRGB()
        {
            var rgb = c.ToArray();
            ApplySrgbGamma(rgb);
            return rgb;
        }

        public override Spectrum FromRGB(Color col, SpectrumType type = SpectrumType.Reflectance)
        {
            double[] rgb = new[] { col.R / 255.0, col.G / 255.0, col.B / 255.0 };

            //RemoveSrgbGamma(rgb);
            var rgbs = new SpectrumRGB(0);
            rgbs.c.SetValues(rgb);
            return rgbs;
        }


        internal static void ApplySrgbGamma(double[] rgb)
        {
            for (int i = 0; i < 3; i++)
            {
                if (rgb[i] < 0.0031308)
                    rgb[i] = 12.92 * rgb[i];
                else
                    rgb[i] = (1.055) * Math.Pow(rgb[i], 1 / 2.4) - 0.055;
            }
        }
        internal static void RemoveSrgbGamma(double[] rgb)
        {
            for (int i = 0; i < 3; i++)
            {
                if (rgb[i] <= 0.04045)
                    rgb[i] = rgb[i] / 12.92;
                else
                    rgb[i] = Math.Pow((rgb[i] + 0.055) / 1.055, 2.4);
            }
        }

        public override Spectrum FromSampled(Vector<double> lambda, Vector<double> v, int n)
        {
            Vector<double> xyz = Vector<double>.Build.Dense(3);
            xyz[0] = xyz[1] = xyz[2] = 0.0;
            double step = (SampledSpectrum.sampledLambdaEnd-SampledSpectrum.sampledLambdaStart)/SampledSpectrum.nSpectralSamples;
            for (int i = 0; i < lambda.Count; i++) {
                xyz[0] += SampledSpectrum.xFit_1931(lambda[i]) * v[i];
                xyz[1] += SampledSpectrum.yFit_1931(lambda[i]) * v[i];
                xyz[2] += SampledSpectrum.zFit_1931(lambda[i]) * v[i];
            }
            double scale = (double)(SampledSpectrum.sampledLambdaEnd - SampledSpectrum.sampledLambdaStart) /
            (double)(SampledSpectrum.CIE_Y_integral * SampledSpectrum.nSpectralSamples);
            xyz[0] *= scale;
            xyz[1] *= scale;
            xyz[2] *= scale;
            return FromXYZ(xyz);
        }

        public override Spectrum FromXYZ(Vector<double> rgb, SpectrumType type = SpectrumType.Reflectance)
        {
            Vector<double> cols = XYZToRGB(rgb);
            return FromRGB(Color.FromArgb((int)cols[0] * 255, (int)cols[1] * 255, (int)cols[2] * 255), type);
        }
    }
}
