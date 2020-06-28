import java.util.*; 

float radius = 50;
float mean=60;
float deviation =15;
ArrayList<Room> rooms = new ArrayList();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Triangle> triangles= new ArrayList<Triangle>();
boolean continu=true;
float timer=0;
boolean Init=false;
boolean state=false;
boolean Delaunay=false;
boolean fillerInitied=false;
int Step=0;
PVector point= new PVector(5*width,5*height);
boolean Span=false;
ArrayList edges = new ArrayList();
Graph graph = new Graph();
QuadTree tree = new QuadTree(new RectangleNode(new PVector(width/2,height/2),new PVector(width/2,height/2)),10);
WorldGrid world;
Room start;
Room Boss;
Filler fill = new Filler();
int seed=1337;
void setup() {
  noiseDetail(20,0.6);
  //noiseSeed(seed);
  //fullScreen();
  randomSeed(seed);
  size(1280,1024);
  //Init();
}

public void Init(){
   for(int i =0; i<150;i++)
  {
     PVector coords = GetRandomPointInCircle(radius);
     coords.add(point);
     Room room = new Room(coords, new PVector(round(NextGaussian(mean,deviation)),round(NextGaussian(mean,deviation))));
     rooms.add(room);
  } 
  world =  new WorldGrid(new PVector(width,height));
  Init=true;
}

public void Flocking()
{
  for(int i = 0; i<rooms.size();i++)
  {
    Room room =(Room)rooms.get(i);
    if(isCollide(room))
    {
        room.Flocking(tree,new PVector(width/2,height/2));
        room.update();
       /* if(room.isDead())
          rooms.remove(i);*/
    }
  }
}
  public void InitFiller(){
    if(!fillerInitied)
    {      
      Edge e = (Edge)edges.get(0);      
      PVector  p =new PVector((int)(e.p1.x/Cell.CellSize),(int)(e.p1.y/Cell.CellSize));
      fill.Fill(world,p, 1);
      fillerInitied=true;
    }
  }

public void draw(){
  clear();
  if(Init){      
    tree = new QuadTree(new RectangleNode(new PVector(width/2,height/2),new PVector(width/2,height/2)),10); 
    stroke(0,255,0); 
  
    for(Room room : rooms){
      tree.Insert(room);
    }
    tree.show();
    Flocking();
    if(!FlockingComplete()){    
      for(Room room : rooms)
      {    
        if(room.Collide)
        {      
          stroke(255,0,0); 
        }
        else
        {
         stroke(0,255,0); 
        }
        rect(room.A.x,room.A.y, room.B.x,room.B.y);
        ellipse(room.A.x+room.B.x/2,room.A.y+room.B.y/2, 5,5);
      
        if(room.Velocity.x>0 && room.Velocity.y>0)
          line(room.A.x+room.B.x/2,room.A.y+room.B.y/2, (room.A.x+room.B.x/2+room.Velocity.x*20), (room.A.y+room.B.y/2+room.Velocity.y*20));       
      }
    }
    else{
      SetRoomCoordToInt();
      fillPoints();
      if(points.size()>3)
      {
        Delaunay();
        Span();              
        InitFiller();
      }
      else
      {
        reset();      
        Init();
      }
    }
    ShowStats();    
    if(fill.queue.size()>0)
    {      
      for(int i = 0; i < 200; i++){
        fill.Work(world);      
      }
    }
    printGrid();
  }
}  
  
  public void printGrid(){     
   stroke(0,0,0);
   ArrayList<Cell> cells = world.GetNodeList();
   //println(cells.size()); 13056 !
   for(Cell c : cells)
   {    
     switch(c.Value){
      case -1 :  
        fill(155,155,155);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 1 :  
        fill(255,255,255);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 2 :  
        fill(0,32,102);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 3 :  
        fill(0, 50, 156);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 4 :  
        fill(0,70,222);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 5 :  
        fill(255,0,0);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 6 :  
        fill(0,255,0);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
      case 7 :  
        fill(255,255,0);
        rect(c.CellPos.x*Cell.CellSize,c.CellPos.y*Cell.CellSize,Cell.CellSize,Cell.CellSize);
      break;       
     }
   }
  }
 
 public void Span(){
  if(Step==2)
  {
    if(!Span)
    {      
      
      for(int i = 0; i < triangles.size(); i++)
      {
         Triangle t = (Triangle)triangles.get(i);
         for(int j = 0; j < triangles.size(); j++)
         {
           Triangle t2 = (Triangle)triangles.get(j);
           t.sharedEdges(t2);
         }
         for(int j = 0;j<t.edges.length;j++)
        {
          if(!edges.contains(t.edges[j]))
            edges.add(t.edges[j]);
        }
      }        
      for(int i =0; i<points.size();i++)
      {    
        graph.addVertex((PVector)points.get(i));    
      }
    
      for(int i = 0;i<edges.size();i++)
      {
         graph.addEdge((Edge)edges.get(i), true);
      }
     graph=graph.SpanTree();
     
     //add randomly some edges to hide your span tree.
     for(int i=0;i<edges.size()*0.07;i++)
     {
       graph.addEdge((Edge)edges.get((int)random(edges.size()/2)),true);
     }
    for (PVector v : graph.map.keySet())
    {     
      Node n = graph.map.get(v);    
      for(Edge e : n.edges)
      {       
        world.print(e.print(),1);
      }   
    }    

     Span=true;
    }
    stroke(255, 0, 0);
    for (PVector v : graph.map.keySet())
    {     
      Node n = graph.map.get(v);    
      for(Edge e : n.edges)
      {       
        line(v.x,v.y,e.p2.x,e.p2.y);
      }   
    }    
  }   
 }
 public void SetRoomCoordToInt(){
     if(Step ==0){
       
     for(int i = 0; i<rooms.size(); i++){
          Room room = (Room) rooms.get(i);
          //is the room still inside the window ?
          if((room.A.x > 0 && room.A.x+room.B.x < width) &&
          (room.A.y > 0 && room.A.y + room.B.y < height))
          {
             room.A=new PVector(round(room.A.x),round(room.A.y));       
          }          
          else
          {
            //if not, remove it.
            rooms.remove(i);            
            //println("room"+ "( "+room.A.x+" , "+room.A.y+" ) erased");
          }
     }
     Step = 1;
    }
 }

 public void fillPoints(){
   if(Step==1)
   {     
     for(Room room : rooms)
     {
       if((room.A.x > 0 && room.A.x+room.B.x < width) &&
          (room.A.y > 0 && room.A.y + room.B.y < height))
       {         
         PVector point = new PVector(room.A.x+room.B.x/2,room.A.y+room.B.y/2);
         world.print(room.Fill(),1);
         points.add(point);
       }
     }
   }
 }
 public void Delaunay(){
   if(Step ==1){

    if(!Delaunay){      
     println(points.size() +" rooms eligible");
     triangles=Triangulate.triangulate(points);   
     Step=2;
     println(triangles.size() +" triangles");
     Delaunay=true;
    }
   }
   /*
   for(Triangle t : triangles){  
    line(t.vertices[0].x, t.vertices[0].y,t.vertices[1].x, t.vertices[1].y);     
    line(t.vertices[1].x, t.vertices[1].y,t.vertices[2].x, t.vertices[2].y);     
    line(t.vertices[2].x, t.vertices[2].y,t.vertices[0].x,t.vertices[0].y);     
   
   }*/
 }
 
 public boolean FlockingComplete(){
  boolean res=true;
  if(!Init)
    return false;
  
  for(Room room : rooms){
    if(isCollide(room)){
     return false;       
    }    
  }
   return true;
 }
 public void ShowStats(){
  textSize(32);
  fill(0,255,0);
  float time=timer/frameRate;
  String text="fps:"+frameRate+"\n"+"time: "+time+"\n" +"iteration :"+timer +'\n'+ "rooms : " + rooms.size()+'\n'+mouseX+" , "+mouseY;
  text(text,width-250,30);
  timer++;
 }
 
public boolean isCollide(Room agent){
  for(Room forbiden :rooms)
  {
    if(forbiden!=agent)
    {
     if(agent.isCollide(forbiden))
     {
       agent.Collide=true;
       forbiden.Collide=true;
       return true;       
     }
     else
     {
       agent.Collide=false;
       forbiden.Collide=false;       
     }
    }
  }
  return false; 
}
 
public float NextGaussian(float mean, float standard_deviation)
{
    float v1, v2, s;
    do
    {
        v1 = 2 * random(0,1) - 1.0f;
        v2 = 2 * random(0,1) - 1.0f;
        s = v1 * v1 + v2 * v2;
    } while (s >= 1 || s == 0);
    s = sqrt((-2 * log(s)) / s);

    return mean + (v1 * s) * standard_deviation;
} 
 
private PVector GetRandomPointInCircle(float radius)
{
  float t = 2 * PI * random(0,1);
  float u = random(0,1) + random(0, 1);
  float r;
  if (u > 1)
      r = 2 - u;
  else
      r = u;
  return new PVector(radius * r * cos(t), radius* r*sin(t));
}

public void reset(){
    world = new WorldGrid(new PVector(width,height));
    rooms.clear();
    Init=false;
    point =new PVector(mouseX,mouseY);
    Init();
    Init=true;
    Step=0;
    points= new ArrayList<PVector>();
    redraw();
    Delaunay=false;
    edges = new ArrayList<PVector>();
    graph = new Graph();
    Span=false;
    fillerInitied=false;
    fill = new Filler();   
}
    
public void mouseClicked(){
  if(mouseButton==LEFT)
  {    
    reset();
  }
  else if (mouseButton==RIGHT)
  {
    PVector p = new PVector((int)(mouseX/Cell.CellSize),(int)(mouseY/Cell.CellSize));
    Cell c = world.GetNode(p);   
    println(c.CellPos+ " "+c.Value +" "+ world.visited[(int)(p.x+p.y*world.size.y)]);
  }
}
    
