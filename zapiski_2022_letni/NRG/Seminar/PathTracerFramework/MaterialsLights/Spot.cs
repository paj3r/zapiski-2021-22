﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>
    /// Example implementation of a diffuse area light
    /// </summary>
    class Spot : Light
    {
        /// <summary>
        /// shape of light
        /// </summary>
        Shape shape;
        /// <summary>
        /// Color of light
        /// </summary>
        Spectrum Lemit;
        double totalWidth;
        double fallOffStart;
        double cosTotalWidth;
        double cosFalloffStart;
        public Spot(Shape s, Spectrum l,double t, double f, double intensity = 1)
        {
            shape = s;
            Lemit = l * intensity;
            totalWidth = t;
            fallOffStart = f;
            cosTotalWidth = Math.Cos(totalWidth);
            cosFalloffStart = Math.Cos(fallOffStart);
        }

        /// <summary>
        /// Intersection of ray with light
        /// </summary>
        /// <param name="r"></param>
        /// <returns></returns>
        public override (double?, SurfaceInteraction) Intersect(Ray r)
        {
            (double? t, SurfaceInteraction si) = shape.Intersect(r);
            if (si != null)
                si.Obj = this;
            return (t, si);
        }

        /// <summary>
        /// Sample point on light
        /// </summary>
        /// <returns></returns>
        public override (SurfaceInteraction, double) Sample()
        {
            return shape.Sample();
        }

        /// <summary>
        /// Samples a light ray from the given point to the light
        /// </summary>
        /// <param name="source">point to start ray from</param>
        /// <returns>light spectrum, sampled wi, pdf of wi, point on light</returns>
        public override (Spectrum, Vector3, double, Vector3) Sample_Li(SurfaceInteraction source)
        {
            (SurfaceInteraction pShape, double pdf) = shape.Sample(source);


            var wi = (pShape.Point - source.Point).Normalize();
            var Li = L(pShape, -wi)*Falloff(-wi) / (pShape.Point - source.Point).LengthSquared();
            return (Li, wi, 1, pShape.Point);
        }

        /// <summary>
        /// Return emmited radiance
        /// </summary>
        /// <param name="intr">point on surface</param>
        /// <param name="w">direction of emission</param>
        /// <returns></returns>
        public override Spectrum L(SurfaceInteraction intr, Vector3 w)
        {
            return (Vector3.Dot(intr.Normal, w) > 0) ? Lemit : Spectrum.CreateSpectral(0);
        }

        /// <summary>
        /// Returns pdf given starting point si and wi
        /// </summary>
        /// <param name="si">starting point</param>
        /// <param name="wi">direction</param>
        /// <returns>pdf</returns>
        public override double Pdf_Li(SurfaceInteraction si, Vector3 wi)
        {
            //return 0;
            return shape.Pdf(si, wi);
        }
        double Falloff(Vector3 w) {
            var wl = w.Normalize();
            double cosTheta = wl.z;
            if (cosTheta<cosTotalWidth) return 0;
            if (cosTheta >= cosFalloffStart) return 1;
            // Compute falloff inside spotlight cone
            double delta = (cosTheta - cosTotalWidth) /
                (cosFalloffStart - cosTotalWidth);
            return (delta* delta)* (delta* delta);
        }

    }
}
