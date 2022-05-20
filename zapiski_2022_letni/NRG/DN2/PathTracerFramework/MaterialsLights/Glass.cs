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
            return Spectrum.ZeroSpectrum;
        }

        /// <summary>
        /// Sample returns the single possible direction
        /// </summary>
        /// <param name="woL">wo in local coordinates</param>
        /// <returns>f as fresnel corrected color, wi as perfect reflection and 1 as pdf</returns>
        public override (Spectrum, Vector3, double) Sample_f(Vector3 woL)
        {
            // perfect specular reflection
            double eta = 1.2;

            //Vector3 wiL = new Vector3(-eta * woL.x,-eta * woL.y, Math.Sign(-woL.z)*(1- eta*eta*(1-woL.z*woL.z)));
            Vector3 wiL = Samplers.UniformSampleSphere();
            Spectrum fr = r * fresnel.Evaluate(Utils.CosTheta(wiL));
            if (Utils.SameHemisphere(woL, wiL))
                return (fr / Utils.AbsCosTheta(wiL), wiL, 1);
            else {
                Random coinflip = new Random();
                if (coinflip.Next(0, 2) == 0 && false) {
                    Vector3 wiLt = new Vector3(-woL.x, -woL.y, woL.z);
                    Spectrum ft = fresnel.Evaluate(Utils.CosTheta(wiL));
                    return (ft / Utils.AbsCosTheta(wiLt), wiLt, 0);
                    //return (fr / Utils.AbsCosTheta(wiL), woL, 0);
                }
                else {
                    bool entering = Utils.CosTheta(woL) > 0;
                    //FresnelDielectric temp = fresnel.Evaluate(Utils.CosTheta(wiL));
                    // compute ray direction for specular transmission
                    Vector3 vec = Refract(woL, Vector3Extensions.Faceforward(new Vector3(0, 0, 1), woL), (float)eta, wiL);
                    if (vec == Vector3.ZeroVector)
                        return (Spectrum.ZeroSpectrum, wiL, 1);
                    Spectrum ft = r * (Spectrum.ZeroSpectrum.FromRGB(Color.White));
                    return (ft / Utils.AbsCosTheta(vec), vec, 1);
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
