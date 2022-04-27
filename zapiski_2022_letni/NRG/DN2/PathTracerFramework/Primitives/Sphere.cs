using System;
using MathNet.Numerics.Integration;

namespace PathTracer
{
    /// <summary>
    /// Sphere Shape template class - NOT implemented completely
    /// </summary>
    class Sphere : Shape
    {
        public double Radius { get; set; }
        public Sphere(double radius, Transform objectToWorld)
        {
            Radius = radius;
            ObjectToWorld = objectToWorld;
        }

        /// <summary>
        /// Ray-Sphere intersection - NOT implemented
        /// </summary>
        /// <param name="r">Ray</param>
        /// <returns>t or null if no hit, point on surface</returns>
        public override (double?, SurfaceInteraction) Intersect(Ray ray)
        {
            //SOURCE: https://github.com/mmp/pbrt-v3/blob/master/src/shapes/sphere.cpp
            Ray r = WorldToObject.Apply(ray);

            // TODO: Compute quadratic sphere coefficients

            // TODO: Initialize _double_ ray coordinate values
            double a = r.d.x * r.d.x + r.d.y * r.d.y + r.d.z * r.d.z;
            double b = 2 * (r.d.x * r.o.x + r.d.y * r.o.y + r.d.z * r.o.z);
            double c = r.o.x * r.o.x + r.o.y * r.o.y + r.o.z * r.o.z - Radius * Radius;

            // TODO: Solve quadratic equation for _t_ values
            double t0, t1;
            bool succ;
            (succ, t0, t1) = Utils.Quadratic(a, b, c);
            if (!succ)
                return (null, null);

            // TODO: Check quadric shape _t0_ and _t1_ for nearest intersection
            if (t1<= Renderer.Epsilon) return (null,null);

            double tShapeHit = t0;
            if (tShapeHit <= Renderer.Epsilon)
            {
                tShapeHit = t1;
            }
            // TODO: Compute sphere hit position and $\phi$
            var pHit = r.Point(tShapeHit); 
            var dpdu = new Vector3(-pHit.y, pHit.x, 0);
            var si = new SurfaceInteraction(pHit, pHit, -r.d, dpdu, this);

            // TODO: Return shape hit and surface interaction
            return (tShapeHit, ObjectToWorld.Apply(si));
        }

        /// <summary>
        /// Sample point on sphere in world
        /// </summary>
        /// <returns>point in world, pdf of point</returns>
        public override (SurfaceInteraction, double) Sample()
        {
            // TODO: Implement Sphere sampling
            Vector3 vec = Samplers.UniformSampleSphere()*Radius;
            var dpdu = new Vector3(-vec.y, vec.x, 0);
            var pdf = 1 / Area();
            var nor = ObjectToWorld.ApplyNormal(vec);
            // TODO: Return surface interaction and pdf
            return (ObjectToWorld.Apply(new SurfaceInteraction(vec, nor, 
                Vector3.ZeroVector, dpdu, this)), pdf);
        }

        public override double Area() { return 4 * Math.PI * Radius * Radius; }

        /// <summary>
        /// Estimates pdf of wi starting from point si
        /// </summary>
        /// <param name="si">point on surface that wi starts from</param>
        /// <param name="wi">wi</param>
        /// <returns>pdf of wi given this shape</returns>
        public override double Pdf(SurfaceInteraction si, Vector3 wi)
        {
            throw new NotImplementedException();
        }

    }
}
