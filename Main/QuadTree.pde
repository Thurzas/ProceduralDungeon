class QuadTree
{
  RectangleNode boundary;
  int Capacity;
  boolean Divided;
  ArrayList<Room> components;
  QuadTree northWest;
  QuadTree southWest;
  QuadTree southEast;
  QuadTree northEast;
  public QuadTree(RectangleNode boundary, int Capacity){
    this.boundary=boundary;
    this.Capacity = Capacity;
    this.components = new ArrayList<Room>();
    this.Divided=false;
  }
  public ArrayList<Room> GetRooms() {
      ArrayList<Room> rooms = new ArrayList<Room>();
      query(boundary, rooms);
      return rooms;
    }
  
  public ArrayList<Room> query(RectangleNode range, ArrayList<Room> founds){
    if(founds==null)
      founds = new ArrayList<Room>();
      
  if(!boundary.Intersects(range))
    return founds;
  else
  {
   for(Room room : components)
   {
     if(range.Contains(new PVector(room.A.x+room.B.x/2,room.A.y+room.B.y/2)))
      founds.add(room);
   }     
  }
  if(this.Divided)
   {
    northWest.query(northWest.boundary, founds); 
    southWest.query(southWest.boundary, founds); 
    southEast.query(southEast.boundary, founds); 
    northEast.query(northEast.boundary, founds); 

    //res.addAll(northWest.query(northWest.boundary)); 
    //res.addAll(southWest.query(southWest.boundary)); 
    //res.addAll(southEast.query(southEast.boundary)); 
    //res.addAll(southWest.query(southWest.boundary)); 
   }
   return founds;
  }
  
  public void SubDivide()
  {
    float x = boundary.A.x;
    float y = boundary.A.y;
    float w = boundary.size.x;
    float h = boundary.size.y;
    
    RectangleNode NE = new RectangleNode(new PVector(x + w/2, y - h/2),new PVector(w/2, h/2 ));
    RectangleNode NW = new RectangleNode(new PVector(x - w/2, y - h/2),new PVector(w/2, h/2 ));
    RectangleNode SE = new RectangleNode(new PVector(x + w/2, y + h/2),new PVector(w/2, h/2 ));
    RectangleNode SW = new RectangleNode(new PVector(x - w/2, y + h/2),new PVector(w/2, h/2 ));
    northWest = new QuadTree(NW,Capacity);
    southWest = new QuadTree(SW,Capacity);
    southEast = new QuadTree(SE,Capacity);
    northEast = new QuadTree(NE,Capacity);
  }
  public void Insert(Room item)
  {
    if(!boundary.Contains(new PVector(item.A.x+item.B.x/2,item.A.y+item.B.y/2)))
     return;
    if(components.size()<=Capacity)
      components.add(item);
    else
    {
      if(!Divided)
      {      
        SubDivide();
        Divided=true;
      }
      northWest.Insert(item);
      northEast.Insert(item);
      southWest.Insert(item);
      southEast.Insert(item);
    }
  }
  
  
  public void show(){
    noFill();
    rectMode(CENTER);
    rect(boundary.A.x,boundary.A.y,boundary.size.x*2,boundary.size.y*2);
     if(Divided)
     {
       northWest.show();
       northEast.show();
       southWest.show();
       southEast.show();
     }
     fill(255,255,255);
     rectMode(CORNER);
  }
}
