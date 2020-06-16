class RectangleNode
{
  PVector A;
  PVector size;
  
  public RectangleNode(PVector A, PVector size)
  {
    this.A=A;
    this.size=size;
  }
  
  public boolean Contains(Room item){
    PVector max = new PVector(A.x + size.x , A.y + size.y );
    PVector forbiddenMax = new PVector(item.A.x + item.B.x , item.A.y + item.B.y );

    if ( max.x < item.A.x || A.x > forbiddenMax.x ) return false;
    if ( max.y < item.A.y || A.y > forbiddenMax.y ) return false;
    
    return true; 
  }
  
    public boolean Contains(PVector item){
      return (item.x > A.x-size.x &&
              item.x < A.x+size.x&&
              item.y > A.y - size.y &&
              item.y < A.y + size.y
              );
  }
  
  public boolean Intersects(RectangleNode range)
  {
    PVector max = new PVector(A.x + size.x , A.y + size.y );
    PVector forbiddenMax = new PVector(range.A.x + range.size.x , range.A.y + range.size.y );

    if ( max.x < range.A.x || A.x > forbiddenMax.x ) return false;
    if ( max.y < range.A.y || A.y > forbiddenMax.y ) return false;

    return true; 
  }
}
