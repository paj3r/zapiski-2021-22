import org.apache.commons.cli.*;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.io.File;

public class Dn1 {
    public static void main (String[] args) throws ParseException, IOException {
        Options options = new Options();
        options.addOption("method", "method", true, "method");
        options.addOption("r", "r", true, "r");
        options.addOption("p", "p", true, "p");
        options.addOption("minx", "min-x", true, "min-x");
        options.addOption("miny", "min-y", true, "min-y");
        options.addOption("minz", "min-z", true, "min-z");
        options.addOption("maxx", "max-x", true, "max-x");
        options.addOption("maxy", "max-y", true, "max-y");
        options.addOption("maxz", "max-z", true, "max-z");
        options.addOption("resx", "res-x", true, "res-x");
        options.addOption("resy", "res-y", true, "res-y");
        options.addOption("resz", "res-z", true, "res-z");
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(options, args);
        String input = args[1];
        String output = args[3];
        String method = cmd.getOptionValue("method");
        float p = Float.parseFloat(cmd.getOptionValue("r"));
        float r = Float.parseFloat(cmd.getOptionValue("r"));
        float minx = Float.parseFloat(cmd.getOptionValue("minx"));
        float miny = Float.parseFloat(cmd.getOptionValue("miny"));
        float minz = Float.parseFloat(cmd.getOptionValue("minz"));
        float maxx = Float.parseFloat(cmd.getOptionValue("maxx"));
        float maxy = Float.parseFloat(cmd.getOptionValue("maxy"));
        float maxz = Float.parseFloat(cmd.getOptionValue("maxz"));
        float resx = Float.parseFloat(cmd.getOptionValue("resx"));
        float resy = Float.parseFloat(cmd.getOptionValue("resy"));
        float resz = Float.parseFloat(cmd.getOptionValue("resz"));
        File inp = new File(input);
        File out = new File(output);
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        ArrayList<String[]> nums_temp = new ArrayList<>();
        String st;
        for(int i=0;(st = br.readLine()) != null;i++){
            nums_temp.add(st.split(" "));
        }
        double[][] nums = new double[nums_temp.size()][4];
        for(int i=0;i<nums.length;i++){
            nums[i]=Arrays.stream(nums_temp.get(i)).mapToDouble(Double::parseDouble).toArray();
        }
        double avgx=0;
        double avgy=0;
        double avgz=0;
        for(int i=0;i<nums.length;i++){
            avgx+=nums[i][0];
            avgy+=nums[i][1];
            avgz+=nums[i][2];
        }
        avgx=avgx/nums.length;
        avgy/=nums.length;
        avgz/=nums.length;
        double mindiff=1000;
        int ix = 0;
        for(int i=0;i<nums.length;i++){
            double temp = Math.abs(avgx-nums[i][0])+Math.abs(avgy-nums[i][1])+Math.abs(avgz-nums[i][2]);
            if(temp<mindiff){
                mindiff=temp;
                ix=i;
            }
        }
        Octree tree = new Octree(new Point(nums[ix][0],nums[ix][1],nums[ix][2],nums[ix][3])
        ,minx,maxx,miny,maxy,minz,maxz);
        for(int i=0;i<nums.length;i++){
            if(i!=ix)
                tree.add(nums[i][0],nums[i][1],nums[i][2],nums[i][3]);
        }
        //tree.root.print();
        //tree.print(tree.root);
        ArrayList<Float> ar=new ArrayList<>();
        double stepx = (maxx-minx)/resx;
        double stepy = (maxy-miny)/resy;
        double stepz = (maxz-minz)/resz;
        DataOutputStream dos = new DataOutputStream(System.out);
        for(double k=minz;k<maxz;k+=stepz){
            for(double j=miny;j<maxy;j+=stepy){
                for(double i=minx;i<=maxx;i=i+stepx){
                    if (method.equals("basic")){
                        Float v=(Float)(float)interpolate_basic(nums, new Point(i,j,k,0), p);
                        //ar.add(v);
                        dos.writeFloat(v);
                        //System.out.println((float)v);
                    }
                    if(method.equals("modified")){
                        Float v=(Float)(float)interpolate_modified(tree, new Point(i,j,k,0), r);
                        ar.add(v);
                        dos.writeFloat(v);
                        //System.out.println((float)v);
                    }
                }
            }
        }
        float max =0;
        float min = 0;
        for(int i=0;i<ar.size();i++){
            float t = ar.get(i);
            if(t>max)
                max=t;
            if(t<min)
                min=t;
        }
        //System.out.println("MIN:"+min+" MAX:"+max);
        dos.flush();

    }
    private static double dist(Point a, Point b){
        return Math.sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)+(a.z-b.z)*(a.z-b.z));
    }
    private static double interpolate_basic(double[][] nums, Point x, double p){
        double sum1 = 0;
        double sum2 = 0;
        for(int i=0;i<nums.length;i++){
            double d = dist(new Point(nums[i][0],nums[i][1],nums[i][2],nums[i][3]), x);
            if(d!=0){
                double wk=1/(Math.pow(d,p));
                sum1+=(wk*nums[i][3]);
                sum2+=wk;
            }
        }
        return sum1/sum2;
    }
    private static double interpolate_modified(Octree tree, Point x, double r){
        Point[] pts = tree.get_by_radius(x,r);
        double sum1 = 0;
        double sum2 = 0;
        for(int i=0;i<pts.length;i++){
            double d = dist(pts[i], x);
            double wk=0;
            if(d!=0){
                wk=Math.pow((r-d)/(r*d), 2);
            }else{
                wk=0;
            }
                sum1+=(wk*pts[i].value);
                sum2+=wk;

        }
        if(pts.length==0)
            return 0;
        return sum1/sum2;
    }
}
