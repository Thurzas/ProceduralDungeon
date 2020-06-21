import java.util.Queue;
public class Filler{
 LinkedList<Cell> queue;
 int [] dx = {0,   1,  1, 1, 0, -1, -1, -1};
 int [] dy = {-1, -1,  0, 1, 1, 1, 0, -1}; 
 public Filler(){
   queue = new LinkedList<Cell>();   
 }
 
 public void Work(WorldGrid world){
   if(queue.size()>0)
   {     
     //Cell c = (Cell)queue.get(0);
     Cell c = queue.peek();
     if(c!=null)
     {       
       Fill(world,c.CellPos, 1);
     }
     queue.remove();
   }
 }
 
 public void Fill(WorldGrid world, PVector currPoint, int target)
 {
   Cell curr =(Cell) world.GetNode(currPoint);
   if( currPoint.x<0 || currPoint.y<0 || currPoint.x > world.size.x -1 || currPoint.y > world.size.y - 1 || world.visited[(int)currPoint.x ][(int)currPoint.y])
     return;
     
    if( curr.Value != target){
       curr.Value=-1;
       return;
    }
    
    if(curr.Value == target)
    {   
       curr.Value=(int)((noise(currPoint.x/5,currPoint.y/5)*3 +2));    
    }      
    world.visited[(int)currPoint.x ][(int)currPoint.y]=true;

    for(int i=0; i < dx.length; i++){
       PVector p = new PVector(currPoint.x+dx[i],currPoint.y+dy[i]);
       Cell c= world.GetNode(p);
       queue.add(c);
     }
   }
 }
