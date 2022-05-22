﻿using MathNet.Numerics.LinearAlgebra;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PathTracer
{
    /// <summary>
    /// Example implementation of a Sampled spectrum
    /// </summary>
    public partial class SampledSpectrum : Spectrum
    {
        public static int sampledLambdaStart = 400;
        public static int sampledLambdaEnd = 700;
        public static int nSpectralSamples = 60;
        static SampledSpectrum X, Y, Z;
        static SampledSpectrum rgbRefl2SpectWhite, rgbRefl2SpectCyan;
        static SampledSpectrum rgbRefl2SpectMagenta, rgbRefl2SpectYellow;
        static SampledSpectrum rgbRefl2SpectRed, rgbRefl2SpectGreen;
        static SampledSpectrum rgbRefl2SpectBlue;
        static SampledSpectrum rgbIllum2SpectWhite, rgbIllum2SpectCyan;
        static SampledSpectrum rgbIllum2SpectMagenta, rgbIllum2SpectYellow;
        static SampledSpectrum rgbIllum2SpectRed, rgbIllum2SpectGreen;
        static SampledSpectrum rgbIllum2SpectBlue;
        public static double CIE_Y_integral = 106.856895;
        static int nRGB2SpectSamples = 32;
        double[] CIEstdD = { 82.754898, 87.120399, 91.486000, 92.458900, 93.431801, 90.056999, 86.682297, 95.773598, 104.864998, 110.935997, 117.008003, 117.410004, 117.811996, 116.335999, 114.861000, 115.391998, 115.922997, 112.366997, 108.810997, 109.082001, 109.353996, 108.578003, 107.802002, 106.295998, 104.790001, 106.238998, 107.689003, 106.046997, 104.404999, 104.224998, 104.045998, 102.023003, 100.000000, 98.167099, 96.334198, 96.061096, 95.788002, 92.236801, 88.685600, 89.345901, 90.006203, 89.802597, 89.599098, 88.648903, 87.698700, 85.493599, 83.288597, 83.493896, 83.699203, 81.862999, 80.026802, 80.120697, 80.214600, 81.246201, 82.277802, 80.280998, 78.284203, 74.002701, 69.721298, 70.665199 };


        public SampledSpectrum()
        {
            //init();
            c = Vector<double>.Build.Dense(nSpectralSamples);
        }
        public SampledSpectrum(double cValue)
        {
            c = Vector<double>.Build.Dense(nSpectralSamples);
            c = c + cValue;
            init();
        }
        private SampledSpectrum(Vector<double> v)
        {
            c = v;
            init();
        }
        public Vector<double> ToXYZ(){
            Vector<double> xyz = Vector<double>.Build.Dense(3);
            xyz[0] = xyz[1] = xyz[2] = 0.0;
            var step = (sampledLambdaEnd - sampledLambdaStart) / nSpectralSamples;
            for (int i = 0; i<nSpectralSamples; ++i) {
                //xyz[0] += X.c[i] * c[i];
                //xyz[1] += Y.c[i] * c[i];
                //xyz[2] += Z.c[i] * c[i];
                xyz[0] += xFit_1931(sampledLambdaStart+(step*i))*c[i];
                xyz[1] += yFit_1931(sampledLambdaStart + (step * i))*c[i];
                xyz[2] += zFit_1931(sampledLambdaStart + (step * i))*c[i];
            }
            double scale = (double)(sampledLambdaEnd - sampledLambdaStart) /
               (double)(CIE_Y_integral * nSpectralSamples);
            xyz[0] *= scale;
            xyz[1] *= scale;
            xyz[2] *= scale;
            return xyz;
        }

        public double y(){ 
            double yy = 0.0;
            for (int i = 0; i<nSpectralSamples; ++i)
                yy += Y.c[i] * c[i];
            return yy* (double)(sampledLambdaEnd - sampledLambdaStart) / (double)(nSpectralSamples);
        }



    public override Spectrum FromSampled(Vector<double> lambda, Vector<double> v, int n)
        {
            SampledSpectrum r = new SampledSpectrum(0.0);
            for (int i = 0; i < nSpectralSamples; ++i)
            {
                double lambda0 = Lerp((double)i / (double)nSpectralSamples,
                                sampledLambdaStart, sampledLambdaEnd);
                double lambda1 = Lerp((double)(i + 1) / (double)nSpectralSamples,
                                     sampledLambdaStart, sampledLambdaEnd);
                r.c[i] = AverageSpectrumSamples(lambda.ToArray(), v.ToArray(), n, lambda0, lambda1);
            }
            return r;
        }
        public static double xFit_1931(double wave)
        {
            double t1 = (wave - 442.0f) * ((wave < 442.0f) ? 0.0624f : 0.0374f);
            double t2 = (wave - 599.8f) * ((wave < 599.8f) ? 0.0264f : 0.0323f);
            double t3 = (wave - 501.1f) * ((wave < 501.1f) ? 0.0490f : 0.0382f);
            return 0.362f * Math.Exp(-0.5f * t1 * t1) + 1.056f * Math.Exp(-0.5f * t2 * t2)
            - 0.065f * Math.Exp(-0.5f * t3 * t3);
        }
        public static double yFit_1931(double wave)
        {
            double t1 = (wave - 568.8f) * ((wave < 568.8f) ? 0.0213f : 0.0247f);
            double t2 = (wave - 530.9f) * ((wave < 530.9f) ? 0.0613f : 0.0322f);
            return 0.821f * Math.Exp(-0.5f * t1 * t1) + 0.286f * Math.Exp(-0.5f * t2 * t2);
        }
        public static double zFit_1931(double wave)
        {
            double t1 = (wave - 437.0f) * ((wave < 437.0f) ? 0.0845f : 0.0278f);
            double t2 = (wave - 459.0f) * ((wave < 459.0f) ? 0.0385f : 0.0725f);
            return 1.217f * Math.Exp(-0.5f * t1 * t1) + 0.681f * Math.Exp(-0.5f * t2 * t2);
        }
        public static SampledSpectrum operator +(SampledSpectrum v1, SampledSpectrum v2)
        {
            v1.c += v2.c;
            return v1;
        }
        public static SampledSpectrum operator *(SampledSpectrum v1, SampledSpectrum v2)
        {
            SampledSpectrum t = (SampledSpectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c.PointwiseMultiply(v2.c);
            return t;
        }

        public static SampledSpectrum operator -(SampledSpectrum v1, SampledSpectrum v2)
        {
            SampledSpectrum t = (SampledSpectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c - v2.c;
            return t;
        }

        public static SampledSpectrum operator *(SampledSpectrum v1, double v2)
        {
            SampledSpectrum t = (SampledSpectrum)Activator.CreateInstance(v1.GetType());
            t.c = (v1.c * v2);
            return t;
        }

        public static SampledSpectrum operator *(double v1, SampledSpectrum v2)
        {
            SampledSpectrum t = new SampledSpectrum();
            t.c = (v1 * v2.c);
            return t;
        }

        public static SampledSpectrum operator /(SampledSpectrum v1, double v2)
        {
            SampledSpectrum t = (SampledSpectrum)Activator.CreateInstance(v1.GetType());
            t.c = v1.c / v2;
            return t;
        }
        public static SampledSpectrum Sqrt(SampledSpectrum s)
        {
            SampledSpectrum ret = Spectrum.CreateSpectral(Vector<double>.Build.Dense(s.c.Count));
            for (int i = 0; i < s.c.Count; ++i)
                ret.c[i] = Math.Sqrt(s.c[i]);
            return ret;

        }
        public SampledSpectrum Clamp()
        {
            for (int i = 0; i < c.Count; i++)
            {
                if (c[i] < 0)
                    c[i] = 0;
            }
            return this;
        }


        public override Spectrum FromRGB(Color c, SpectrumType type)
        {
            //Treba je nardit da bojo operacije delale tud za sampledspectrum
            SampledSpectrum r = new SampledSpectrum();
            double[] rgb = new[] { c.R / 255.0, c.G / 255.0, c.B / 255.0 };
            if (type == SpectrumType.Reflectance)
            {
                if (rgb[0] <= rgb[1] && rgb[0] <= rgb[2])
                {
                    r += rgb[0] * rgbRefl2SpectWhite;
                    if (rgb[1] <= rgb[2])
                    {
                        r += (rgb[1] - rgb[0]) * rgbRefl2SpectCyan;
                        r += (rgb[2] - rgb[1]) * rgbRefl2SpectBlue;
                    }
                    else
                    {
                        r += (rgb[2] - rgb[0]) * rgbRefl2SpectCyan;
                        r += (rgb[1] - rgb[2]) * rgbRefl2SpectGreen;
                    }
                }
                else if (rgb[1] <= rgb[0] && rgb[1] <= rgb[2])
                {
                    r += rgb[1] * rgbRefl2SpectWhite;
                    if (rgb[0] <= rgb[2])
                    {
                        r += (rgb[0] - rgb[1]) * rgbRefl2SpectMagenta;
                        r += (rgb[2] - rgb[0]) * rgbRefl2SpectBlue;
                    }
                    else
                    {
                        r += (rgb[2] - rgb[1]) * rgbRefl2SpectMagenta;
                        r += (rgb[0] - rgb[2]) * rgbRefl2SpectRed;
                    }
                }
                else
                {
                    r += rgb[2] * rgbRefl2SpectWhite;
                    if (rgb[0] <= rgb[1])
                    {
                        r += (rgb[0] - rgb[2]) * rgbRefl2SpectYellow;
                        r += (rgb[1] - rgb[0]) * rgbRefl2SpectGreen;
                    }
                    else
                    {
                        r += (rgb[1] - rgb[2]) * rgbRefl2SpectYellow;
                        r += (rgb[0] - rgb[1]) * rgbRefl2SpectRed;
                    }

                }
            }
            else
            {
                if (rgb[0] <= rgb[1] && rgb[0] <= rgb[2])
                {
                    r += rgb[0] * rgbIllum2SpectWhite;
                    if (rgb[1] <= rgb[2])
                    {
                        r += (rgb[1] - rgb[0]) * rgbIllum2SpectCyan;
                        r += (rgb[2] - rgb[1]) * rgbIllum2SpectBlue;
                    }
                    else
                    {
                        r += (rgb[2] - rgb[0]) * rgbIllum2SpectCyan;
                        r += (rgb[1] - rgb[2]) * rgbIllum2SpectGreen;
                    }
                }
                else if (rgb[1] <= rgb[0] && rgb[1] <= rgb[2])
                {
                    r += rgb[1] * rgbIllum2SpectWhite;
                    if (rgb[0] <= rgb[2])
                    {
                        r += (rgb[0] - rgb[1]) * rgbIllum2SpectMagenta;
                        r += (rgb[2] - rgb[0]) * rgbIllum2SpectBlue;
                    }
                    else
                    {
                        r += (rgb[2] - rgb[1]) * rgbIllum2SpectMagenta;
                        r += (rgb[0] - rgb[2]) * rgbIllum2SpectRed;
                    }
                }
                else {
                    r += rgb[2] * rgbIllum2SpectWhite;
                    if (rgb[0] <= rgb[1])
                    {
                        r += (rgb[0] - rgb[2]) * rgbIllum2SpectYellow;
                        r += (rgb[1] - rgb[0]) * rgbIllum2SpectGreen;
                    }
                    else
                    {
                        r += (rgb[1] - rgb[2]) * rgbIllum2SpectYellow;
                        r += (rgb[0] - rgb[1]) * rgbIllum2SpectRed;
                    }
                }
            }
            return r.Clamp();
        }
        public SampledSpectrum createUniorm() {
            c = Vector<double>.Build.Dense(nSpectralSamples);
            double step = (sampledLambdaEnd - sampledLambdaStart) / nSpectralSamples;
            for (int i = 0; i < nSpectralSamples; i++) { 
                c[i] = 1;
            }
            
            return new SampledSpectrum(c).Clamp();

        }

        public SampledSpectrum CreateCIEstdD()
        {
            c = Vector<double>.Build.Dense(nSpectralSamples);
            double step = (sampledLambdaEnd - sampledLambdaStart) / nSpectralSamples;
            for (int i = 0; i < nSpectralSamples; i++)
            {
                c[i] = CIEstdD[i];
            }

            return new SampledSpectrum(c).Clamp();

        }

        public SampledSpectrum createMagenta()
        {
            c = Vector<double>.Build.Dense(nSpectralSamples);
            double step = (sampledLambdaEnd - sampledLambdaStart) / nSpectralSamples;
            for (int i = 0; i < nSpectralSamples; i++)
            {
                c[i] = 0;
            }
            c[0] = 1;
            c[1] = 1;
            c[2] = 1;

            return new SampledSpectrum(c).Clamp();

        }


        public override double[] ToRGB()
        {
            var xyz = ToXYZ();
            //xyz = Vector<double>.Build.Dense(3);
            //xyz[0] = 0.95;
            //xyz[1] = 1;
            //xyz[2] = 1;

            return XYZToRGB(xyz).ToArray();
        }

        public void init()
        {
            X = new SampledSpectrum();
            Y = new SampledSpectrum();
            Z = new SampledSpectrum();
            rgbRefl2SpectWhite= new SampledSpectrum();
            rgbRefl2SpectCyan = new SampledSpectrum();
            rgbRefl2SpectMagenta = new SampledSpectrum();
            rgbRefl2SpectYellow = new SampledSpectrum();
            rgbRefl2SpectRed = new SampledSpectrum();
            rgbRefl2SpectGreen = new SampledSpectrum();
            rgbRefl2SpectBlue = new SampledSpectrum();
            rgbIllum2SpectWhite = new SampledSpectrum();
            rgbIllum2SpectCyan = new SampledSpectrum();
            rgbIllum2SpectMagenta = new SampledSpectrum();
            rgbIllum2SpectYellow = new SampledSpectrum();
            rgbIllum2SpectRed = new SampledSpectrum();
            rgbIllum2SpectGreen = new SampledSpectrum();
            rgbIllum2SpectBlue = new SampledSpectrum();
            double[] RGB2SpectLambda = {
    380.000000, 390.967743, 401.935486, 412.903229, 423.870972, 434.838715,
    445.806458, 456.774200, 467.741943, 478.709686, 489.677429, 500.645172,
    511.612915, 522.580627, 533.548340, 544.516052, 555.483765, 566.451477,
    577.419189, 588.386902, 599.354614, 610.322327, 621.290039, 632.257751,
    643.225464, 654.193176, 665.160889, 676.128601, 687.096313, 698.064026,
    709.031738, 720.000000};

            double[] RGBRefl2SpectWhite = {
    1.0618958571272863e+00, 1.0615019980348779e+00, 1.0614335379927147e+00,
    1.0622711654692485e+00, 1.0622036218416742e+00, 1.0625059965187085e+00,
    1.0623938486985884e+00, 1.0624706448043137e+00, 1.0625048144827762e+00,
    1.0624366131308856e+00, 1.0620694238892607e+00, 1.0613167586932164e+00,
    1.0610334029377020e+00, 1.0613868564828413e+00, 1.0614215366116762e+00,
    1.0620336151299086e+00, 1.0625497454805051e+00, 1.0624317487992085e+00,
    1.0625249140554480e+00, 1.0624277664486914e+00, 1.0624749854090769e+00,
    1.0625538581025402e+00, 1.0625326910104864e+00, 1.0623922312225325e+00,
    1.0623650980354129e+00, 1.0625256476715284e+00, 1.0612277619533155e+00,
    1.0594262608698046e+00, 1.0599810758292072e+00, 1.0602547314449409e+00,
    1.0601263046243634e+00, 1.0606565756823634e+00};

            double[] RGBRefl2SpectCyan = {
    1.0414628021426751e+00,  1.0328661533771188e+00,  1.0126146228964314e+00,
    1.0350460524836209e+00,  1.0078661447098567e+00,  1.0422280385081280e+00,
    1.0442596738499825e+00,  1.0535238290294409e+00,  1.0180776226938120e+00,
    1.0442729908727713e+00,  1.0529362541920750e+00,  1.0537034271160244e+00,
    1.0533901869215969e+00,  1.0537782700979574e+00,  1.0527093770467102e+00,
    1.0530449040446797e+00,  1.0550554640191208e+00,  1.0553673610724821e+00,
    1.0454306634683976e+00,  6.2348950639230805e-01,  1.8038071613188977e-01,
    -7.6303759201984539e-03, -1.5217847035781367e-04, -7.5102257347258311e-03,
    -2.1708639328491472e-03, 6.5919466602369636e-04,  1.2278815318539780e-02,
    -4.4669775637208031e-03, 1.7119799082865147e-02,  4.9211089759759801e-03,
    5.8762925143334985e-03,  2.5259399415550079e-02};

            double[] RGBRefl2SpectMagenta = {
    9.9422138151236850e-01,  9.8986937122975682e-01, 9.8293658286116958e-01,
    9.9627868399859310e-01,  1.0198955019000133e+00, 1.0166395501210359e+00,
    1.0220913178757398e+00,  9.9651666040682441e-01, 1.0097766178917882e+00,
    1.0215422470827016e+00,  6.4031953387790963e-01, 2.5012379477078184e-03,
    6.5339939555769944e-03,  2.8334080462675826e-03, -5.1209675389074505e-11,
    -9.0592291646646381e-03, 3.3936718323331200e-03, -3.0638741121828406e-03,
    2.2203936168286292e-01,  6.3141140024811970e-01, 9.7480985576500956e-01,
    9.7209562333590571e-01,  1.0173770302868150e+00, 9.9875194322734129e-01,
    9.4701725739602238e-01,  8.5258623154354796e-01, 9.4897798581660842e-01,
    9.4751876096521492e-01,  9.9598944191059791e-01, 8.6301351503809076e-01,
    8.9150987853523145e-01,  8.4866492652845082e-01};

            double[] RGBRefl2SpectYellow = {
    5.5740622924920873e-03,  -4.7982831631446787e-03, -5.2536564298613798e-03,
    -6.4571480044499710e-03, -5.9693514658007013e-03, -2.1836716037686721e-03,
    1.6781120601055327e-02,  9.6096355429062641e-02,  2.1217357081986446e-01,
    3.6169133290685068e-01,  5.3961011543232529e-01,  7.4408810492171507e-01,
    9.2209571148394054e-01,  1.0460304298411225e+00,  1.0513824989063714e+00,
    1.0511991822135085e+00,  1.0510530911991052e+00,  1.0517397230360510e+00,
    1.0516043086790485e+00,  1.0511944032061460e+00,  1.0511590325868068e+00,
    1.0516612465483031e+00,  1.0514038526836869e+00,  1.0515941029228475e+00,
    1.0511460436960840e+00,  1.0515123758830476e+00,  1.0508871369510702e+00,
    1.0508923708102380e+00,  1.0477492815668303e+00,  1.0493272144017338e+00,
    1.0435963333422726e+00,  1.0392280772051465e+00};

            double[] RGBRefl2SpectRed = {
    1.6575604867086180e-01,  1.1846442802747797e-01,  1.2408293329637447e-01,
    1.1371272058349924e-01,  7.8992434518899132e-02,  3.2205603593106549e-02,
    -1.0798365407877875e-02, 1.8051975516730392e-02,  5.3407196598730527e-03,
    1.3654918729501336e-02,  -5.9564213545642841e-03, -1.8444365067353252e-03,
    -1.0571884361529504e-02, -2.9375521078000011e-03, -1.0790476271835936e-02,
    -8.0224306697503633e-03, -2.2669167702495940e-03, 7.0200240494706634e-03,
    -8.1528469000299308e-03, 6.0772866969252792e-01,  9.8831560865432400e-01,
    9.9391691044078823e-01,  1.0039338994753197e+00,  9.9234499861167125e-01,
    9.9926530858855522e-01,  1.0084621557617270e+00,  9.8358296827441216e-01,
    1.0085023660099048e+00,  9.7451138326568698e-01,  9.8543269570059944e-01,
    9.3495763980962043e-01,  9.8713907792319400e-01};

            double[] RGBRefl2SpectGreen = {
    2.6494153587602255e-03,  -5.0175013429732242e-03, -1.2547236272489583e-02,
    -9.4554964308388671e-03, -1.2526086181600525e-02, -7.9170697760437767e-03,
    -7.9955735204175690e-03, -9.3559433444469070e-03, 6.5468611982999303e-02,
    3.9572875517634137e-01,  7.5244022299886659e-01,  9.6376478690218559e-01,
    9.9854433855162328e-01,  9.9992977025287921e-01,  9.9939086751140449e-01,
    9.9994372267071396e-01,  9.9939121813418674e-01,  9.9911237310424483e-01,
    9.6019584878271580e-01,  6.3186279338432438e-01,  2.5797401028763473e-01,
    9.4014888527335638e-03,  -3.0798345608649747e-03, -4.5230367033685034e-03,
    -6.8933410388274038e-03, -9.0352195539015398e-03, -8.5913667165340209e-03,
    -8.3690869120289398e-03, -7.8685832338754313e-03, -8.3657578711085132e-06,
    5.4301225442817177e-03,  -2.7745589759259194e-03};

            double[] RGBRefl2SpectBlue = {
    9.9209771469720676e-01,  9.8876426059369127e-01,  9.9539040744505636e-01,
    9.9529317353008218e-01,  9.9181447411633950e-01,  1.0002584039673432e+00,
    9.9968478437342512e-01,  9.9988120766657174e-01,  9.8504012146370434e-01,
    7.9029849053031276e-01,  5.6082198617463974e-01,  3.3133458513996528e-01,
    1.3692410840839175e-01,  1.8914906559664151e-02,  -5.1129770932550889e-06,
    -4.2395493167891873e-04, -4.1934593101534273e-04, 1.7473028136486615e-03,
    3.7999160177631316e-03,  -5.5101474906588642e-04, -4.3716662898480967e-05,
    7.5874501748732798e-03,  2.5795650780554021e-02,  3.8168376532500548e-02,
    4.9489586408030833e-02,  4.9595992290102905e-02,  4.9814819505812249e-02,
    3.9840911064978023e-02,  3.0501024937233868e-02,  2.1243054765241080e-02,
    6.9596532104356399e-03,  4.1733649330980525e-03};
            double[] RGBIllum2SpectWhite = {
    1.1565232050369776e+00, 1.1567225000119139e+00, 1.1566203150243823e+00,
    1.1555782088080084e+00, 1.1562175509215700e+00, 1.1567674012207332e+00,
    1.1568023194808630e+00, 1.1567677445485520e+00, 1.1563563182952830e+00,
    1.1567054702510189e+00, 1.1565134139372772e+00, 1.1564336176499312e+00,
    1.1568023181530034e+00, 1.1473147688514642e+00, 1.1339317140561065e+00,
    1.1293876490671435e+00, 1.1290515328639648e+00, 1.0504864823782283e+00,
    1.0459696042230884e+00, 9.9366687168595691e-01, 9.5601669265393940e-01,
    9.2467482033511805e-01, 9.1499944702051761e-01, 8.9939467658453465e-01,
    8.9542520751331112e-01, 8.8870566693814745e-01, 8.8222843814228114e-01,
    8.7998311373826676e-01, 8.7635244612244578e-01, 8.8000368331709111e-01,
    8.8065665428441120e-01, 8.8304706460276905e-01};

            double[] RGBIllum2SpectCyan = {
    1.1334479663682135e+00,  1.1266762330194116e+00,  1.1346827504710164e+00,
    1.1357395805744794e+00,  1.1356371830149636e+00,  1.1361152989346193e+00,
    1.1362179057706772e+00,  1.1364819652587022e+00,  1.1355107110714324e+00,
    1.1364060941199556e+00,  1.1360363621722465e+00,  1.1360122641141395e+00,
    1.1354266882467030e+00,  1.1363099407179136e+00,  1.1355450412632506e+00,
    1.1353732327376378e+00,  1.1349496420726002e+00,  1.1111113947168556e+00,
    9.0598740429727143e-01,  6.1160780787465330e-01,  2.9539752170999634e-01,
    9.5954200671150097e-02,  -1.1650792030826267e-02, -1.2144633073395025e-02,
    -1.1148167569748318e-02, -1.1997606668458151e-02, -5.0506855475394852e-03,
    -7.9982745819542154e-03, -9.4722817708236418e-03, -5.5329541006658815e-03,
    -4.5428914028274488e-03, -1.2541015360921132e-02};

            double[] RGBIllum2SpectMagenta = {
    1.0371892935878366e+00,  1.0587542891035364e+00,  1.0767271213688903e+00,
    1.0762706844110288e+00,  1.0795289105258212e+00,  1.0743644742950074e+00,
    1.0727028691194342e+00,  1.0732447452056488e+00,  1.0823760816041414e+00,
    1.0840545681409282e+00,  9.5607567526306658e-01,  5.5197896855064665e-01,
    8.4191094887247575e-02,  8.7940070557041006e-05,  -2.3086408335071251e-03,
    -1.1248136628651192e-03, -7.7297612754989586e-11, -2.7270769006770834e-04,
    1.4466473094035592e-02,  2.5883116027169478e-01,  5.2907999827566732e-01,
    9.0966624097105164e-01,  1.0690571327307956e+00,  1.0887326064796272e+00,
    1.0637622289511852e+00,  1.0201812918094260e+00,  1.0262196688979945e+00,
    1.0783085560613190e+00,  9.8333849623218872e-01,  1.0707246342802621e+00,
    1.0634247770423768e+00,  1.0150875475729566e+00};

            double[] RGBIllum2SpectYellow = {
    2.7756958965811972e-03,  3.9673820990646612e-03,  -1.4606936788606750e-04,
    3.6198394557748065e-04,  -2.5819258699309733e-04, -5.0133191628082274e-05,
    -2.4437242866157116e-04, -7.8061419948038946e-05, 4.9690301207540921e-02,
    4.8515973574763166e-01,  1.0295725854360589e+00,  1.0333210878457741e+00,
    1.0368102644026933e+00,  1.0364884018886333e+00,  1.0365427939411784e+00,
    1.0368595402854539e+00,  1.0365645405660555e+00,  1.0363938240707142e+00,
    1.0367205578770746e+00,  1.0365239329446050e+00,  1.0361531226427443e+00,
    1.0348785007827348e+00,  1.0042729660717318e+00,  8.4218486432354278e-01,
    7.3759394894801567e-01,  6.5853154500294642e-01,  6.0531682444066282e-01,
    5.9549794132420741e-01,  5.9419261278443136e-01,  5.6517682326634266e-01,
    5.6061186014968556e-01,  5.8228610381018719e-01};

            double[] RGBIllum2SpectRed = {
    5.4711187157291841e-02,  5.5609066498303397e-02,  6.0755873790918236e-02,
    5.6232948615962369e-02,  4.6169940535708678e-02,  3.8012808167818095e-02,
    2.4424225756670338e-02,  3.8983580581592181e-03,  -5.6082252172734437e-04,
    9.6493871255194652e-04,  3.7341198051510371e-04,  -4.3367389093135200e-04,
    -9.3533962256892034e-05, -1.2354967412842033e-04, -1.4524548081687461e-04,
    -2.0047691915543731e-04, -4.9938587694693670e-04, 2.7255083540032476e-02,
    1.6067405906297061e-01,  3.5069788873150953e-01,  5.7357465538418961e-01,
    7.6392091890718949e-01,  8.9144466740381523e-01,  9.6394609909574891e-01,
    9.8879464276016282e-01,  9.9897449966227203e-01,  9.8605140403564162e-01,
    9.9532502805345202e-01,  9.7433478377305371e-01,  9.9134364616871407e-01,
    9.8866287772174755e-01,  9.9713856089735531e-01};

            double[] RGBIllum2SpectGreen = {
    2.5168388755514630e-02,  3.9427438169423720e-02,  6.2059571596425793e-03,
    7.1120859807429554e-03,  2.1760044649139429e-04,  7.3271839984290210e-12,
    -2.1623066217181700e-02, 1.5670209409407512e-02,  2.8019603188636222e-03,
    3.2494773799897647e-01,  1.0164917292316602e+00,  1.0329476657890369e+00,
    1.0321586962991549e+00,  1.0358667411948619e+00,  1.0151235476834941e+00,
    1.0338076690093119e+00,  1.0371372378155013e+00,  1.0361377027692558e+00,
    1.0229822432557210e+00,  9.6910327335652324e-01,  -5.1785923899878572e-03,
    1.1131261971061429e-03,  6.6675503033011771e-03,  7.4024315686001957e-04,
    2.1591567633473925e-02,  5.1481620056217231e-03,  1.4561928645728216e-03,
    1.6414511045291513e-04,  -6.4630764968453287e-03, 1.0250854718507939e-02,
    4.2387394733956134e-02,  2.1252716926861620e-02};

            double[] RGBIllum2SpectBlue = {
    1.0570490759328752e+00,  1.0538466912851301e+00,  1.0550494258140670e+00,
    1.0530407754701832e+00,  1.0579930596460185e+00,  1.0578439494812371e+00,
    1.0583132387180239e+00,  1.0579712943137616e+00,  1.0561884233578465e+00,
    1.0571399285426490e+00,  1.0425795187752152e+00,  3.2603084374056102e-01,
    -1.9255628442412243e-03, -1.2959221137046478e-03, -1.4357356276938696e-03,
    -1.2963697250337886e-03, -1.9227081162373899e-03, 1.2621152526221778e-03,
    -1.6095249003578276e-03, -1.3029983817879568e-03, -1.7666600873954916e-03,
    -1.2325281140280050e-03, 1.0316809673254932e-02,  3.1284512648354357e-02,
    8.8773879881746481e-02,  1.3873621740236541e-01,  1.5535067531939065e-01,
    1.4878477178237029e-01,  1.6624255403475907e-01,  1.6997613960634927e-01,
    1.5769743995852967e-01,  1.9069090525482305e-01};
            for (int i = 0; i < nSpectralSamples; i++)
            {
                double wl0 = Lerp(i / nSpectralSamples,
                            sampledLambdaStart, sampledLambdaEnd);
                X.c[i] = xFit_1931(wl0);
                Y.c[i] = yFit_1931(wl0);
                Z.c[i] = zFit_1931(wl0);

            }

            for (int i = 0; i < nSpectralSamples; ++i)
            {
                double wl0 = Lerp((double)i / (double)(nSpectralSamples),
                                 sampledLambdaStart, sampledLambdaEnd);
                double wl1 = Lerp((double)(i + 1) / (double)(nSpectralSamples),
                                 sampledLambdaStart, sampledLambdaEnd);
                rgbRefl2SpectWhite.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectWhite,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectCyan.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectCyan,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectMagenta.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectMagenta,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectYellow.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectYellow,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectRed.c[i] = AverageSpectrumSamples(
                    RGB2SpectLambda, RGBRefl2SpectRed, nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectGreen.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectGreen,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbRefl2SpectBlue.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBRefl2SpectBlue,
                                           nRGB2SpectSamples, wl0, wl1);

                rgbIllum2SpectWhite.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectWhite,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectCyan.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectCyan,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectMagenta.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectMagenta,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectYellow.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectYellow,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectRed.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectRed,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectGreen.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectGreen,
                                           nRGB2SpectSamples, wl0, wl1);
                rgbIllum2SpectBlue.c[i] =
                    AverageSpectrumSamples(RGB2SpectLambda, RGBIllum2SpectBlue,
                                           nRGB2SpectSamples, wl0, wl1);
            }
        }

        public override Spectrum FromXYZ(Vector<double> xyz, SpectrumType type = SpectrumType.Reflectance)
        {
            Vector<double> rgb = XYZToRGB(xyz);
            return FromRGB(Color.FromArgb((int)rgb[0] * 255, (int)rgb[1] * 255, (int)rgb[2] * 255), type);
        }
    }
}
