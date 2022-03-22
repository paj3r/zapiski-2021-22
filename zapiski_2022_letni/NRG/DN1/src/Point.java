public class Point {
    Point[] children;
    public double x, y, z;
    public double value;

    public Point(double x, double y, double z, double value) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.value = value;
        this.children = new Point[8];
    }
    public void print(){
        System.out.print(x + " , "+ y + " , "+ z + " ; "+ value + "\n");
    }
}
