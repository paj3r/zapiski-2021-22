  float minX;
  float minY;
  float minZ;
  float maxX;
  float maxY;
  float maxZ;
  boolean isX;
  String force;
  float gravity = 9.81;
  int typecount=0;
  int emcount=0;
  Type[] types = new Type[10];
  Emitter[] emitters = new Emitter[10];
  Particle p;
  int prevtime;  
void setup(){
  
  String file = "../simple_01.txt";
  String[] els = loadStrings(file);
  size(900,900);
  smooth();
  background(255);
  for (int i=0;i<els.length;i++){
    String[] parsed = els[i].split(" ");
    if (parsed[0].equals("space")){
      minX = float(parsed[1]);
      minY = float(parsed[2]);
      minZ = float(parsed[3]);
      maxX = float(parsed[4]);
      maxY = float(parsed[5]);
      maxZ = float(parsed[6]);
    }
    if (parsed[0].equals("gravity")){
      force = parsed[0];
      if(parsed.length>1)
        gravity = float(parsed[1]);  
    }
    if(parsed[0].equals("type")){
      Type temp = new Type(float(parsed[1].substring(1, parsed[1].length()-1)), float(parsed[2].substring(1, parsed[2].length()-1)));
      //types = append(types, temp);
      types[typecount]=temp;
      typecount++;
      //tip = temp;
      //print(tip.mass+" "+tip.radius);
      
    }
    if(parsed[0].equals("emitter")){
      float tx= float(parsed[2].substring(1,2));
      float ty = float(parsed[3]);
      float tz = float(parsed[4].substring(0,1));
      float mx = float(parsed[5].substring(1,2));
      float my = float(parsed[6]);
      float mz = float(parsed[7].substring(0,1));
      float rate = float(parsed[8].substring(1, parsed[8].length()-1));
      int[] id = {int(parsed[9].substring(1,parsed[9].length()-1))};
      int max= int(parsed[10].substring(1, parsed[10].length()-1));
      emitters[emcount]=new Emitter(ty, ty, tz, rate, mx, my, mz, mx, my, mz, id, max);
      emcount++;
    }
  }
  if((maxX-minX)>(maxY-minY))
    isX=true;
  else
    isX=false;
  print(emitters[0].maxParticleCount);
  p = new Particle(0.0,0.0,100.0,5.0,0.0,0.0,20.0,30.0);
  prevtime=millis();
}

void draw() {
  background(255);
  strokeWeight(map(p.rad/2,0,maxX-minX,0, 900));
  int tdiff = millis()-prevtime;
  float[]pos = p.getnewpos(tdiff);
  stroke(0, pos[2]);
  point(pos[0], pos[1]);
  prevtime=millis();
}

class Type{
  float mass;
  float radius;
  Type(float m, float r){
    this.mass = m;
    this.radius = r;
  }
}

class Emitter{
  float x;
  float y;
  float z;
  float rate;
  float minVx;
  float minVy;
  float minVz;
  float maxVx;
  float maxVy;
  float maxVz;
  int[] ids;
  int maxParticleCount;
  
  Emitter(float x, float y, float z, float rate, float mvx, float mvy, float mvz, float xvx, float xvy, float xvz, int[] ids, int mpc){
    this.x =x;
    this.y=y;
    this.z=z;
    this.rate=rate;
    this.minVx = mvx;
    this.minVy=mvy;
    this.minVz = mvz;
    this.maxVx= xvx;
    this.maxVy =xvy;
    this.maxVz=xvz;
    this.ids= ids;
    this.maxParticleCount=mpc;
  }
}

class Particle{
  float posx;
  float posy;
  float posz;
  float vx;
  float vy;
  float vz;
  float mass;
  float rad;
  
  Particle(float x, float y, float z, float vx,float vy,float vz, float m, float r){
    this.posx=x;
    this.posy=y;
    this.posz=z;
    this.vx=vx;
    this.vy=vy;
    this.vz=vz;
    this.mass=m;
    this.rad=r;
  }
  float[] getnewpos(int timediff){
    float td = float(timediff)/1000.0;
    this.posx=this.posx+(td*vx);
    this.posy=this.posy+(td*vy);
    this.posz = this.posz+(td*vz);
    this.vy -=td*gravity;
    if(this.posx+this.rad>maxX || this.posx-(this.rad)<minX){
      this.posx=this.posx-(td*vx);
      this.vx = -this.vx;
    }
    if(this.posy+this.rad>maxY || this.posy-(this.rad)<minY){
      this.posy=this.posy-(td*vy);
      this.vy = -this.vy;
    }
    if(this.posz+this.rad>maxZ || this.posz-(this.rad)<minZ){
      this.posz=this.posz-(td*vz);
      this.vz = -this.vz;
    }
    float ex= map(this.posx, minX+this.rad,maxX-this.rad, 0, width);
    float ey= map(this.posy, minY+this.rad,maxY-this.rad, height, 0);
    float ez = map(this.posz, minZ,maxZ, 50, 255);
    float[] out = {ex, ey, ez};
    return out;
  }
}
