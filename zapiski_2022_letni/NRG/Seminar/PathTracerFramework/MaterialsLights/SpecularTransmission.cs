using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using MathNet.Numerics.LinearAlgebra;

namespace PathTracer
{
    /// <summary>
    /// Example implementation of a specular reflection material
    /// </summary>
    public class SpecularTransmission : BxDF
    {
        /// <summary>
        /// material color
        /// </summary>
        private Spectrum r;
        /// <summary>
        /// Fresnel parameters
        /// </summary>
        private FresnelDielectric fresnel;
        public enum TransportMode { Radiance, Imporatance }
        private TransportMode mode;


        public override bool IsSpecular => true;

        public SpecularTransmission(Spectrum r, double fresnel1, double fresnel2)
        {
            this.r = r;
            fresnel = new FresnelDielectric(fresnel1, fresnel2);
        }

        /// <summary>
        /// f of perfect specular transmission is zero (probability also)
        /// </summary>
        /// <param name="wo"></param>
        /// <param name="wi"></param>
        /// <returns></returns>
        public override Spectrum f(Vector3 wo, Vector3 wi)
        {
            return Spectrum.CreateSpectral(0);
        }

        /// <summary>
        /// Sample returns the single possible direction
        /// </summary>
        /// <param name="woL">wo in local coordinates</param>
        /// <returns>f as fresnel corrected color, wi as perfect reflection and 1 as pdf</returns>
        public override (Spectrum, Vector3, double) Sample_f(Vector3 woL)
        {
            Random coinflip = new Random();
            // figure out which eta transmits and which incides
            bool entering = Utils.CosTheta(woL) > 0;
            double eta = 1.6;
            if (entering)
            {
                eta = 1 / eta;
            }
            Vector3 wiL = Samplers.UniformSampleSphere();
            //FresnelDielectric temp = fresnel.Evaluate(Utils.CosTheta(wiL));
            // compute ray direction for specular transmission
            int ix = coinflip.Next(0, SampledSpectrum.nSpectralSamples);
            double step = 0.02 / SampledSpectrum.nSpectralSamples;
            Vector<double> newcol = Vector<double>.Build.Dense(SampledSpectrum.nSpectralSamples);
            newcol[ix] = r.c[ix];
            Vector3 vec = Refract(woL, Vector3Extensions.Faceforward(new Vector3(0, 0, 1), woL), (float)eta, wiL);
            if (vec==Vector3.ZeroVector)
                return (Spectrum.CreateSpectral(0), wiL, 0);
            Spectrum ft = Spectrum.CreateSpectral(newcol) * (Spectrum.createSpectralUni());
            return (ft / Utils.AbsCosTheta(vec), vec, 1);
        }

        /// <summary>
        /// Probability of any pair is 0
        /// </summary>
        /// <param name="wo"></param>
        /// <param name="wi"></param>
        /// <returns></returns>
        public override double Pdf(Vector3 wo, Vector3 wi)
        {
            return 0;
        }
    }
}
