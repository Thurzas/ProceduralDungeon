import java.util.*; 
import processing.core.*;
public class Node
{
   Node parent;
   int rank;
   LinkedList<Edge> edges;   
   PVector point;
   public Node(LinkedList<Edge> edges){
     this.edges = edges;
   }
   
   public Node(PVector point)
   {
      this.point = point;
      this.edges=new LinkedList<Edge>();
      this.parent=this;
   }

   public void addEdge(Edge e) throws Exception{
     if(e.p1==this.point)
       edges.add(e);     
     else if(e.GetOpposite().p1==this.point)
       edges.add(e.GetOpposite());
     else
       throw new Exception("edge from a stranger");
   }

   public void removeEdge(Edge e){
     if(edges.contains(e))
       edges.remove(e);       
   }
   
   public LinkedList GetEdges(){
    return edges; 
   }

   public boolean hasEdge(PVector p1)
   {
     for(Edge e : edges)
     {
       if(e.p2.x==p1.x && e.p2.y==p1.y)
       {
         return  true;         
       }
     }
     return false;
   }
   
         
    public Node GetParent()
    {
       return parent; 
    }
    
    public void SetParent(Node parent)
    {
      this.parent= parent; 
    }
    
    public int GetRank()
    {
       return rank; 
    }
    
    @Override
    public boolean equals(Object a)
    {
      boolean res=false;
      if(a!=null)
      {
        if(a instanceof Node)
        {
          Node other = (Node)a;
          if(this.point.x == other.point.x && this.point.y==other.point.y)
            res=true;
        }              
      }
        
      return res;
    }
    
    
    public void Increment()
    {
      rank++;
    }
}
