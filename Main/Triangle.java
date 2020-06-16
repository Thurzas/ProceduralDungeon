import processing.core.PVector;

public class Triangle {
  
  public PVector[] vertices;  
  public Edge[] edges;
  public Triangle() { 
    vertices = new PVector[3];
    edges = new Edge[3];
  }
  
  public Triangle(PVector p1, PVector p2, PVector p3) {
    vertices = new PVector[3];
    edges = new Edge[3];
    vertices[0]=p1;
    vertices[1]=p2;
    vertices[2]=p3;
    edges[0]= new Edge(p1,p2);
    edges[1]= new Edge(p2,p3);
    edges[2]= new Edge(p3,p1);
  }
  
  private void SetEdge(int i, Edge e)
  {
     this.edges[i]=e;      
  }

  public Edge GetEdge(int i)
  {
     return edges[i]; 
  }
     
  public boolean sharedEdges(Triangle other){ 
    boolean res = false;
    for(int i=0;i<edges.length;i++)
    {
      for(int j=0;j<edges.length;j++)
      {
        if(edges[i].equals(other.edges[j]))
        {
          other.edges[j]=edges[i];
          res=true;
        }       
      }            
    }
    return res;
  }

  public boolean sharesVertex(Triangle other) {
    return vertices[0] == other.vertices[0] || vertices[0] == other.vertices[1] || vertices[0] == other.vertices[2] ||
           vertices[1] == other.vertices[0] || vertices[1] == other.vertices[1] || vertices[1] == other.vertices[2] || 
           vertices[2] == other.vertices[0] || vertices[2] == other.vertices[1] || vertices[2] == other.vertices[2];
  }
  
  @Override
  public String toString(){
    int count=0;
    String res ="Triangle ( "+vertices[0]+", "+vertices[1]+", "+vertices[2]+") ";
    if(GetEdge(0)!=null)
    {
      count++;
      res+="[ "+GetEdge(0).toString()+"], ";
    }
    if(GetEdge(1)!=null)
    {
      res+="[ "+GetEdge(1).toString()+"], ";
      count++;
    }
    if(GetEdge(2)!=null)
    {
      res+="[ "+GetEdge(2).toString()+"]";
      count++;
    }
     res+= "edges :"+count;
     return res;
  }
}
