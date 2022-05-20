using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>
    /// Base BxDF class for implementations to inherit
    /// </summary>
    public abstract class BxDF
    {

        public Vector3 Refract(Vector3 wi, Vector3 n, float eta, Vector3 wt)
        {
            double cosThetaI = Vector3.Dot(n, wi);
            double sin2ThetaI = Math.Max(0, 1 - (cosThetaI * cosThetaI));
            double sin2ThetaT = eta * eta * sin2ThetaI;
            if (sin2ThetaT >= 1) return Vector3.ZeroVector;
            double cosThetaT = Math.Sqrt(1 - sin2ThetaT);
            return eta * (-wi) + (eta * cosThetaI - cosThetaT) * n;
        }
        /// <summary>
        /// True, if material is specular
        /// </summary>
        public virtual bool IsSpecular => false;

        /// <summary>
        /// Returns f(wo,wi) 
        /// </summary>
        /// <param name="wo">wo in local coords</param>
        /// <param name="wi">wi in local coords</param>
        /// <returns>f(wo,wi)</returns>
        public abstract Spectrum f(Vector3 wo, Vector3 wi);

        /// <summary>
        /// Sample wi direction according to wo in local coords
        /// </summary>
        /// <param name="woL"></param>
        /// <returns>f, sampled direction wi in local coords and pdf(wo, wi)</returns>
        public abstract (Spectrum, Vector3, double) Sample_f(Vector3 woL);

        /// <summary>
        /// pdf of (wo,wi) 
        /// </summary>
        /// <param name="wo">wo in local coords</param>
        /// <param name="wi">wi in local coords</param>
        /// <returns></returns>
        public abstract double Pdf(Vector3 wo, Vector3 wi);

    }
}

