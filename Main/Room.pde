class Room
{
  PVector A;
  PVector B;
  PVector Velocity;
  PVector acceleration;
  boolean Collide;
  float maxspeed=40;
  float maxforce=0.1;
  int lifespan;
  float alignWeight= 1;
  float cohesionWeight=1;
  float separateWeight=2;
  public Room(PVector A, PVector B){
    this.A = A;
    this.B = B;
    this.Velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
    this.lifespan=50;
  }

  public boolean isCollide(Room other){
    boolean res= false;
    if(A.x < other.A.x + other.B.x &&
       A.x + B.x > other.A.x &&
       A.y < other.A.y + other.B.y&&
       A.y + B.y > other.A.y )
    {
      lifespan--;
      res=true;      
    }
    return res;
  }
 
  public boolean Contains(PVector point){
    boolean res= false;
    if(A.x < point.x &&
       A.x + B.x > point.x &&
       A.y < point.y&&
       A.y + B.y > point.y )
    {
      res=true;
    }
    return res;
  }
  
  public void update(){
    Velocity.add(acceleration);
    Velocity.limit(maxspeed);
    A.add(Velocity);
    acceleration.mult(maxforce);      
  }
  public boolean isDead()
  {
    return lifespan <0;
  }
  
  public ArrayList<PVector> Fill(){
     ArrayList<PVector> points = new ArrayList<PVector>();    
     int limit = (int)((B.x/Cell.CellSize)*(B.y/Cell.CellSize));
     for(int i =0; i<B.y/Cell.CellSize;i++){
       for(int j =0; j<B.y/Cell.CellSize;j++){
         points.add(new PVector((int)(A.x/Cell.CellSize + i) ,(int)(A.y/Cell.CellSize + j)));         
         
       }
     }
     return points;
  }
/*
  public boolean isCollide(Room item){
    PVector max = new PVector(A.x + B.x, A.y + B.y );
    PVector forbiddenMax = new PVector(item.A.x + item.B.x ,item.A.y + item.B.y );

    if ( max.x < item.A.x || A.x > forbiddenMax.x )
    {
      Collide=false;
      return false;
    }
    if ( max.y < item.A.y || A.y > forbiddenMax.y )
    {
      Collide=false;
      return false;      
    }
    Collide= true;
    return true; 
  }*/
  
  private PVector LocalCohesion(ArrayList<Room> neighbors)
  {
    PVector v = new PVector(0, 0);
    PVector Mid = new PVector(A.x +B.x/ 2, A.y +B.y/ 2);

    if (neighbors.size() == 0)
        return v;
    
    for(Room room : neighbors)
    {
      if(this!=room)
      {
        if(isCollide(room))
        {          
          v.x += (room.A.x/2);
          v.y += (room.A.y/2);        
        }
        }
    }

    v.x /= neighbors.size();
    v.y /= neighbors.size();
    v = new PVector(v.x - Mid.x, v.y - Mid.y);
    v.normalize();
    return v;
  }

  
  public PVector Align(ArrayList<Room> neighbors)
  {
      PVector v = new PVector(0, 0);
      if (neighbors.size() == 0)
          return v;
  
      for(Room room : neighbors)
      {       
        if(this!=room)
        {
          if(isCollide(room))
          {        
            v.add(room.Velocity);
          }
        }
      }
  
      v.x /= neighbors.size();
      v.y /= neighbors.size();
      v.normalize();
      return v;
  }

  private PVector Separate(List<Room> neighbors)
  {
      PVector v = new PVector(0, 0);
      PVector Mid = new PVector(A.x +B.x/ 2, A.y +B.y/ 2);

      if (neighbors.size() == 0)
          return v;

      for(Room room : neighbors)
      {
        if(this!=room)
        {
          if(isCollide(room))
          {
            PVector MidRoom = new PVector(room.A.x +room.B.x/ 2, room.A.y +room.B.y/ 2);
            float d = PVector.dist(Mid,MidRoom);
            if(d>0)
            {
              PVector diff = PVector.sub(Mid,MidRoom); 
              diff.div(d);
              v.add(diff); 
            }         
          }
        }
      }
      v.x /= neighbors.size();
      v.y /= neighbors.size();
      v.normalize();
      return v;

  }
  

  private PVector seek(PVector target){
    PVector desired = PVector.sub(target,A);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,Velocity);  
    steer.limit(maxforce);
    return steer;
  }
  
  private PVector flee(PVector target){
    return seek(target).mult(-1);
  }
   
  public void ApplyForce(PVector force)
  {
    acceleration.add(force);    
  }
  
  void FleeMe(ArrayList<Room> neighbors){
    for(Room room : neighbors){
      PVector flee = seek(new PVector(A.x+B.x/2,A.y+B.y/2)).mult(-1.7);
      flee.normalize();
      room.ApplyForce(flee);
    }
  }
    
  private void Flocking(QuadTree tree, PVector target)
  {
    float Weight=dist(A.x,A.y,target.x,target.y);
    ArrayList<Room> neighbors= new ArrayList<Room>();
    tree.query(new RectangleNode(A,new PVector(B.x*10,B.y*10)),neighbors);
    PVector Separation = Separate(neighbors);
    PVector Align = Align(neighbors);
    PVector steer =seek(target);
    steer.mult(0.3);
    Separation.mult(100);
    Align.mult(0.1);
    ApplyForce(steer);    
    ApplyForce(Separation);
    ApplyForce(Align);
    Velocity.normalize();
    Velocity.mult(Weight/neighbors.size());     
  }
}
