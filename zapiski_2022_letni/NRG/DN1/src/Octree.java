import java.util.ArrayList;

public class Octree {
    public Point root;
    public double minx,maxx,miny,maxy,minz,maxz;

    public Octree(Point p, double minx, double maxx, double miny, double maxy, double minz, double maxz) {
        this.root = p;
        this.minx = minx;
        this.maxx = maxx;
        this.miny = miny;
        this.maxy = maxy;
        this.minz = minz;
        this.maxz = maxz;
    }
    public int i = 0;
    boolean inBounds(double x, double y, double z){
        if(x>=minx && x<=maxx)
            if(y>=miny && y<=maxy)
                return z >= minz && z <= maxz;
        return false;
    }

    private Point add_int(Point cur, double x, double y, double z, double val){
        if(cur==null)
            return new Point(x,y,z,val);
        if(cur.x==x && cur.y==y && cur.z==z)
            return cur;
        else
            cur.children[getpos(cur,x,y,z)]=add_int(cur.children[getpos(cur,x,y,z)],x,y,z,val);
        return cur;
    }
    public Point add(double x, double y, double z, double val){
        return add_int(this.root, x,y,z,val);
    }

    public Point get(double x,double y,double z){
        return get_int(this.root, x, y, z);
    }
    private Point get_int(Point cur, double x, double y, double z){
        if(cur.x==x && cur.y==y && cur.z==z)
            return cur;
        else
            return get_int(cur.children[getpos(cur,x,y,z)],x,y,z);
    }
    public Point[] get_by_radius(Point b, double r){
        ArrayList<Point> li = get_by_rad(this.root, b, new ArrayList<Point>(), r);
        Point[] pts = new Point[li.size()];
        pts = li.toArray(pts);
        return pts;
    }
    private ArrayList<Point> get_by_rad(Point cur, Point b , ArrayList<Point> acc, double r){
        if(cur==null)
            return acc;
        double d = dist(cur,b);
        if(d<r)
            acc.add(cur);
        for(int i=0;i<8;i++){
            if(cur.children[i]!=null){
                double d2 = dist(cur,cur.children[i]);
                if(d2<d || d2<r)
                    get_by_rad(cur.children[i], b, acc, r);
            }
        }
        return acc;

    }
    private static double dist(Point a, Point b){
        return Math.sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)+(a.z-b.z)*(a.z-b.z));
    }

    public int getpos(Point cur, double x, double y, double z){
        if(x<cur.x && y<cur.y && z<cur.z)
            return 0;
        else if(x>cur.x && y<cur.y && z<cur.z)
            return 1;
        else if(x<cur.x && y>cur.y && z<cur.z)
            return 2;
        else if(x>cur.x && y>cur.y && z<cur.z)
            return 3;
        else if(x<cur.x && y<cur.y && z>cur.z)
            return 4;
        else if(x>cur.x && y<cur.y && z>cur.z)
            return 5;
        else if(x<cur.x && y>cur.y && z>cur.z)
            return 6;
        else return 7;
    }
    public void print(Point cur){
        if(cur!=null){
            cur.print();
            System.out.print("//");
            for(int i=0;i<8;i++){
                if(cur.children[i]!=null){
                    System.out.print("Level "+i+ ":");
                    this.print(cur.children[i]);
                }
            }
        }
    }

}
