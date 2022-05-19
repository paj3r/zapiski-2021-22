using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PathTracer.Samplers;

namespace PathTracer
{
    class PathTracer
    {
        /// <summary>
        /// Given Ray r and Scene s, trace the ray over the scene and return the estimated radiance
        /// </summary>
        /// <param name="r">Ray direction</param>
        /// <param name="s">Scene to trace</param>
        /// <returns>Estimated radiance in the ray direction</returns>
        public Spectrum Li(Ray r, Scene s)
        {
            var L = Spectrum.CreateSpectral(0);
            var beta = Spectrum.CreateSpectral(1);
            var nBounces = 0;
            while (nBounces < 20) { 
                (double? dist, SurfaceInteraction isect) = s.Intersect(r);
                if (dist == null || isect == null)
                {
                    break;
                }
                var wo = new Ray(r.o, r.d);
                if(isect.Obj is Light)
                {
                    L.AddTo(beta * isect.Le(-wo.d));
                    break;
                }
                (Spectrum f, Vector3 wi, double pdf, bool isSpecular) =
                    ((Shape)isect.Obj).BSDF.Sample_f(-wo.d, isect);
                if (f.IsBlack()) { break; }
                if (nBounces > 3) {
                    var q = 1 - beta.Max();
                    Random rand = new Random();
                    if (rand.NextDouble() < q) {
                        break;
                    }
                    beta = beta / (1 - q);
                }
                beta = (SampledSpectrum)((beta * f * Vector3.AbsDot(isect.Normal, wi)) / pdf);
                r = isect.SpawnRay(wi);
                //importance sampling
                Spectrum temp = Light.UniformSampleOneLight(isect, s);
                //if (temp.c.Average() < f.c.Average())
                //  break;
                L.AddTo(beta * temp);
                nBounces++;
            }
            /* Implement */
            return L;
        }

    }
}
