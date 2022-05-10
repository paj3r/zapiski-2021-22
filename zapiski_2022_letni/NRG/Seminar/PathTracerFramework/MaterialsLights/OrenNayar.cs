using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>s
    /// Example BxDF implementation of a perfect lambertian surface
    /// </summary>
    public class OrenNayar : BxDF
    {
        private Spectrum kd;
        private double delta;
        private double albedo;
        public OrenNayar(Spectrum r, double del)
        {
            kd = r;
            delta = del;
        }

        /// <summary>
        /// Lambertian f is kd/pi
        /// </summary>
        /// <param name="wo">output vector</param>
        /// <param name="wi">input vector</param>
        /// <returns></returns>
        public override Spectrum f(Vector3 wo, Vector3 wi)
        {
            var A = 1 - ((delta * delta) / (2 * ((delta * delta) + 0.33)));
            var B = 0.45 * ((delta * delta) / ((delta * delta) + 0.09));

            var alpha = new Vector3(0, 0, 0);
            var beta = new Vector3(0, 0, 0);
            if (new Vector3(wo.x, wo.y, 0).Length() > (new Vector3(wi.x, wi.y, 0).Length()))
            {
                alpha = wo.Clone();
                beta = wi.Clone();
            }
            else
            {
                alpha = wi.Clone();
                beta = wo.Clone();
            }
            if (!Utils.SameHemisphere(wo, wi))
                return Spectrum.ZeroSpectrum;
            return (kd * Utils.PiInv) * (A + B * Math.Max(0, Utils.CosPhi(wi - wo))
                * Utils.SinTheta(alpha) * Utils.TanTheta(beta));
        }

        /// <summary>
        /// Cosine weighted sampling of wi
        /// </summary>
        /// <param name="wo">wo in local</param>
        /// <returns>(f, wi, pdf)</returns>
        public override (Spectrum, Vector3, double) Sample_f(Vector3 wo)
        {
            var wi = Samplers.CosineSampleHemisphere();
            if (wo.z < 0)
                wi.z *= -1;
            double pdf = Pdf(wo, wi);
            return (f(wo, wi), wi, pdf);
        }

        /// <summary>
        /// returns pdf(wo,wi) as |cosTheta|/pi
        /// </summary>
        /// <param name="wo">output vector in local</param>
        /// <param name="wi">input vector in local</param>
        /// <returns></returns>
        public override double Pdf(Vector3 wo, Vector3 wi)
        {
            if (!Utils.SameHemisphere(wo, wi))
                return 0;

            return Math.Abs(wi.z) * Utils.PiInv; // wi.z == cosTheta
        }
    }
}
