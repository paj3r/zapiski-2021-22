using MathNet.Numerics.LinearAlgebra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;

namespace PathTracer
{
    /// <summary>
    /// Example implementation of a specular reflection material
    /// </summary>
    public class Glass : BxDF
    {
        /// <summary>
        /// material color
        /// </summary>
        private Spectrum r;
        /// <summary>
        /// Fresnel parameters
        /// </summary>
        private FresnelDielectric fresnel;
        private Spectrum t;

        public override bool IsSpecular => true;

        public Glass(Spectrum r, double fresnel1, double fresnel2)
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
            // perfect specular reflection
            double eta = 3;

            //Vector3 wiL = new Vector3(-eta * woL.x,-eta * woL.y, Math.Sign(-woL.z)*(1- eta*eta*(1-woL.z*woL.z)));
            Vector3 wiL = Samplers.UniformSampleSphere();
            Spectrum fr = r * fresnel.Evaluate(Utils.CosTheta(wiL));
            //Spectrum fr = r;
            if (Utils.SameHemisphere(woL, wiL)) {
                var tee = Utils.AbsCosTheta(wiL);
                return (fr / Utils.AbsCosTheta(wiL), wiL, 1);
            }
            else {
                Random coinflip = new Random();
                if (coinflip.NextDouble() < Utils.AbsCosTheta(wiL)) {
                    Vector3 wiLt = new Vector3(-woL.x, -woL.y, woL.z);
                    Spectrum ft = fresnel.Evaluate(Utils.CosTheta(wiL));
                    var tee = Utils.AbsCosTheta(wiL);
                    return (ft / Utils.AbsCosTheta(wiL), wiLt, tee);
                    //return (fr / Utils.AbsCosTheta(wiL), woL, 0);
                }
                else {
                    bool entering = Utils.CosTheta(woL) > 0;
                    if (entering)
                    {
                        eta = 1 / eta;
                    }
                    //FresnelDielectric temp = fresnel.Evaluate(Utils.CosTheta(wiL));
                    // compute ray direction for specular transmission
                    double sum = 0;
                    for (int i = 0; i < SampledSpectrum.nSpectralSamples; i++) {
                        sum += r.c[i];
                    }
                    double ix = coinflip.NextDouble()*sum;
                    double newsum = 0;
                    int index = 0;
                    for (int i = 0; i < SampledSpectrum.nSpectralSamples; i++)
                    {
                        if (newsum >= ix) { 
                            index = i;
                            break;
                        }
                        newsum += r.c[i];
                    }
                    double step = 1.5/SampledSpectrum.nSpectralSamples;
                    Vector<double> newcol = Vector<double>.Build.Dense(SampledSpectrum.nSpectralSamples);
                    newcol[index] = r.c[index];
                    Vector3 vec = Refract(woL, Vector3Extensions.Faceforward(new Vector3(0, 0, 1), woL), (float)(eta-(step*index)), wiL);
                    if (vec == Vector3.ZeroVector)
                        return (Spectrum.ZeroSpectrum, wiL, 1);
                    Spectrum ft = r * (Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Reflectance));
                    var tee = Utils.AbsCosTheta(wiL);
                    return (ft / Utils.AbsCosTheta(wiL), vec, 1-tee);
                }
            }


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
