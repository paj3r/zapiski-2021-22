using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>
    /// Represents a scene to be rendered
    /// </summary>
    public class Scene
    {

        /// <summary>
        /// Elements contains all scene elements (lights and shapes)
        /// </summary>
        public List<Primitive> Elements { get; set; } = new List<Primitive>();
        public List<Light> Lights => Elements.Where(x => x is Light).Cast<Light>().ToList();
        public Vector3 CameraOrigin { get; set; } = new Vector3(0, 0, 0);
        public double AspectRatio { get; set; } = 16.0 / 9;

        public double ImagePlaneWidth { get; set; } = 16;
        public double ImagePlaneHeight => ImagePlaneWidth / AspectRatio;
        public double ImagePlaneDistance { get; set; } = 8;
        public double ImagePlaneVerticalOffset { get; set; } = 0;

        /// <summary>
        /// Finds the closest intersection of ray with scene
        /// </summary>
        /// <param name="r">ray</param>
        /// <returns>t of the closest intersection and the intersction object</returns>
        public (double?, SurfaceInteraction) Intersect(Ray r)
        {
            double? mint = null;
            SurfaceInteraction si = null;
            foreach (var sh in Elements)
            {
                (double? t, SurfaceInteraction shi) = sh.Intersect(r);
                if (t.HasValue && t > Renderer.Epsilon && (!mint.HasValue || t < mint))
                {
                    mint = t.Value;
                    si = shi;
                }
            }

            return (mint, si);
        }
        /// <summary>
        /// Returns true if points are not ocludded (no element is between them)
        /// </summary>
        /// <param name="p1">Point 1</param>
        /// <param name="p2">Point 2</param>
        /// <returns>true if no occlusion occurs</returns>
        public bool Unoccluded(Vector3 p1, Vector3 p2)
        {
            Ray r = new Ray(p1, p2 - p1);
            (double? t, SurfaceInteraction it) = Intersect(r);

            if (!t.HasValue || (p2 - it.Point).Length() < Renderer.Epsilon)
                return true;

            return false;
        }


        /// <summary>
        /// Generate Cornell Box Geometry
        /// </summary>
        /// <returns>Generated scene</returns>
        public static Scene CornellBox()
        {
            var s = new Scene()
            {
                CameraOrigin = new Vector3(278, 274.4, -800),
                AspectRatio = 1.0 / 1.0,
                ImagePlaneWidth = 5.5
            };

            Shape el;
            //SampledSpectrum.init();
            var t = Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Illuminant).ToRGB();
            Color c = Color.FromArgb((int)(t[0] * 255), (int)(t[1] * 255), (int)(t[2] * 255));
            var t2 = Spectrum.CreateSpectral(0).FromRGB(Color.Blue, Spectrum.SpectrumType.Reflectance).ToRGB();
            Color c2 = Color.FromArgb((int)(t2[0] * 255), (int)(t2[1] * 255), (int)(t2[2] * 255));

            // floor
            el = new Quad(556.0, 559.2, Transform.Translate(556.0 / 2, 0, 559.2 / 2).A(Transform.RotateX(-90)));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance)));
            s.Elements.Add(el);

            // celing
            el = new Quad(556.0, 559.2, Transform.Translate(556.0 / 2, 548.8, 559.2 / 2).A(Transform.RotateX(90)));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance)));
            //el.BSDF.Add(new Lambertian(Spectrum.createSpectralUni()));
            s.Elements.Add(el);

            // back
            t = Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Reflectance).ToRGB();
            c = Color.FromArgb((int)(t[0] * 255), (int)(t[1] * 255), (int)(t[2] * 255));
            el = new Quad(556.0, 548.8, Transform.Translate(556.0 / 2, 548.8 / 2, 559.2).A(Transform.RotateX(180)));
            //el.BSDF.Add(new Lambertian(Spectrum.ZeroSpectrum.FromRGB(Color.Yellow, Spectrum.SpectrumType.Reflectance)));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance)));
            //el.BSDF.Add(new SpecularReflection(Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Reflectance), 1, 1.5));
            //el.BSDF.Add(new Lambertian(Spectrum.createSpectralUni()));
            s.Elements.Add(el);

            //right
            t = Spectrum.CreateSpectral(0).FromRGB(Color.Green, Spectrum.SpectrumType.Reflectance).ToRGB();
            c = Color.FromArgb((int)(t[0] * 255), (int)(t[1] * 255), (int)(t[2] * 255));
            el = new Quad(559.2, 548.8, Transform.Translate(556.0, 548.8 / 2, 559.2 / 2).A(Transform.RotateY(90)));
            //el.BSDF.Add(new Lambertian(Spectrum.ZeroSpectrum.FromRGB(Color.Green, Spectrum.SpectrumType.Reflectance)));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance)));
            //el.BSDF.Add(new Lambertian(Spectrum.createSpectralUni()));
            s.Elements.Add(el);

            //left
            t = Spectrum.CreateSpectral(0).FromRGB(Color.Red, Spectrum.SpectrumType.Reflectance).ToRGB();
            c = Color.FromArgb((int)(t[0] * 255), (int)(t[1] * 255), (int)(t[2] * 255));
            el = new Quad(559.2, 548.8, Transform.Translate(0, 548.8 / 2, 559.2 / 2).A(Transform.RotateY(-90)));
            //el.BSDF.Add(new Lambertian(Spectrum.ZeroSpectrum.FromRGB(Color.Red, Spectrum.SpectrumType.Reflectance)));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance)));
            //el.BSDF.Add(new Lambertian(Spectrum.createSpectralUni()));
            s.Elements.Add(el);

            t = Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Illuminant).ToRGB();
            c = Color.FromArgb((int)(t[0] * 255), (int)(t[1] * 255), (int)(t[2] * 255));
            s.Elements.Add(new DiffuseAreaLight(new Quad(20, 20, Transform.Translate(278, 548, 280).A(Transform.RotateX(90))), Spectrum.createSpectralCIE(), 15));
            //s.Elements.Add(new Spot(new Quad(30, 30, Transform.Translate(278, 548, 280).A(Transform.RotateX(90))),Spectrum.createSpectralCIE(), 1,100, 100));


            el = new Sphere(100, Transform.Translate(220, 200, 280).A(Transform.RotateY(-30)));
            //el = new Sphere(100, Transform.Translate(150, 100, 420));
            //el.BSDF.Add(new OrenNayar(Spectrum.createSpectralMag(),0));
            //el.BSDF.Add(new Glass(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance), 0, 0));
            el.BSDF.Add(new Glass(Spectrum.CreateSpectral(0).FromRGB(c, Spectrum.SpectrumType.Reflectance), 0, 0));
            s.Elements.Add(el);

            //s.Elements.Add(new DiffuseAreaLight( new Sphere(100, Transform.Translate(400, 100, 230)), Spectrum.Create(1), 20));
            el = new Sphere(100, Transform.Translate(300, 100, 400).A(Transform.RotateY(-30)));
            //el.BSDF.Add(new MicrofacetReflection(Spectrum.ZeroSpectrum.FromRGB(Color.White), 1.5, 1, 0.05));
            //el.BSDF.Add(new SpecularReflection(Spectrum.ZeroSpectrum.FromRGB(Color.White),0,0));
            //el.BSDF.Add(new SpecularReflection(Spectrum.CreateSpectral(0).FromRGB(Color.White, Spectrum.SpectrumType.Reflectance),1,1.5));
            el.BSDF.Add(new Lambertian(Spectrum.CreateSpectral(0).FromRGB(c2, Spectrum.SpectrumType.Reflectance)));
            //el.BSDF.Add(new SpecularTransmission(Spectrum.ZeroSpectrum.FromRGB(Color.White), 0, 0));
            //el.BSDF.Add(new Glass(Spectrum.ZeroSpectrum.FromRGB(Color.White, Spectrum.SpectrumType.Reflectance), 0,0, Spectrum.ZeroSpectrum.FromRGB(Color.White, Spectrum.SpectrumType.Reflectance)));
            s.Elements.Add(el);

            return s;

        }
    }
}
