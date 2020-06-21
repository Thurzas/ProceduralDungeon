import java.util.*; 
import processing.core.*;  
class Graph { 
  
    // We use Hashmap to store the edges in the graph 
    //public HashMap<PVector, Node> map; 
    public HashMap<PVector,Node> map;
    
    public Graph()
    {
      this.map = new HashMap<PVector,Node>();      
    }
    
    public void addVertex(PVector s) 
    { 
        map.put(s,new Node(s)); 
    }
    
    // This function adds the edge 
    // between source to destination 
    public void addEdge(PVector source, 
                        PVector destination, 
                        boolean bidirectional) 
    { 
        Edge e = new Edge(source,destination);
        if (!map.containsKey(source)) 
            addVertex(source); 
  
        if (!map.containsKey(destination)) 
            addVertex(destination); 
            
        map.get(source).edges.add(e); 
        if (bidirectional == true) { 
            map.get(destination).edges.add(e.GetOpposite()); 
        } 
    } 
  
    public void addEdge(Edge e, boolean bidirectional) 
    {   
        if (!map.containsKey(e.p1)) 
            addVertex(e.p2); 
  
        if (!map.containsKey(e.p2)) 
            addVertex(e.p1); 
  
        map.get(e.p1).edges.add(e); 
        if (bidirectional == true) { 
            map.get(e.p2).edges.add(e.GetOpposite()); 
        } 
    } 
  
    // This function gives the count of vertices 
    public int getVertexCount() 
    { 
       return map.keySet().size(); 
    } 
  
    // This function gives the count of edges 
    public int getEdgesCount(boolean bidirection) 
    { 
        int count = 0; 
        for (PVector v : map.keySet()) { 
            count += map.get(v).edges.size(); 
        } 
        if (bidirection == true) { 
            count = count / 2; 
        }                            
        return count;
    } 
  
    // This function gives whether 
    // a vertex is present or not. 
    public void hasVertex(PVector s) 
    { 
        if (map.containsKey(s)) { 
            System.out.println("The graph contains "
                               + s + " as a vertex."); 
        } 
        else { 
            System.out.println("The graph does not contain "
                               + s + " as a vertex."); 
        } 
    } 
  
    // This function gives whether an edge is present or not. 
    public void hasEdge(PVector s, PVector d) 
    { 
      Node n = map.get(s);
      for(int i =0; i<n.edges.size(); i++)
      {
         Edge e = (Edge)n.edges.get(i);
         if (e.p2==d) { 
          //System.out.println("The graph has an edge between " + s + " and " + d + "."); 
        } 
        else { 
        //  System.out.println("The graph has no edge between " + s + " and " + d + "."); 
        }  
      }
    } 
  
    public boolean hasEdge(Edge e) 
    { 
      boolean res=false;
      Node n = map.get(e.p1);
      for(int i =0; i<n.edges.size(); i++)
      {
          Edge e2 = (Edge)n.edges.get(i);
          if (e2.equals(e)|| e2.GetOpposite().equals(e)) { 
            res=true;
            //System.out.println("The graph has an edge between " + e.p1 + " and " + e.p2 + "."); 
          } 
          else { 
            //System.out.println("The graph has no edge between " + e.p1 + " and " + e.p2 + "."); 
        }  
      }
      return res;
    } 
    
    public Graph SpanTree(){
      Graph res= new Graph();
      LinkedList<Edge> edges = new LinkedList<Edge>();
      for(PVector v : map.keySet())
      {
        edges.addAll(map.get(v).GetEdges());        
      }      
      Collections.sort(edges);
      
      for(PVector v : map.keySet())
      {
        res.addVertex(map.get(v).point);        
      }
      int i = 0;
      while(res.getEdgesCount(true)< this.getVertexCount()-1 && i<edges.size())
      {
        Edge e = edges.get(i);        
        Node x=res.map.get(e.p1);
        Node y=res.map.get(e.p2);        
        Node xRoot = res.Find(x);
        Node yRoot = res.Find(y);
        
        if(!xRoot.equals(yRoot))
        {         
          if(!res.hasEdge(e))
          {
           res.addEdge(e,true);
           Union(res,e.p1,e.p2);           
          }
        }
        i++;
      }

      return res;
    }
   
    public void Union(Graph sub, PVector x, PVector y )
    {
       Node xRoot= Find(sub.map.get(x));
       Node yRoot = Find(sub.map.get(y));
       //System.out.print("Xroot before union :" +Find(sub.map.get(x)).toString()+ " "+ xRoot);
       //System.out.println(" Yroot before union :" +Find(sub.map.get(y)).toString()+ " "+ yRoot);
       if(!xRoot.equals(yRoot))
       {
          if(xRoot.GetRank() < yRoot.GetRank())
            xRoot.SetParent(yRoot);
          else
          {            
            yRoot.SetParent(xRoot);
            if(xRoot.GetRank()==yRoot.GetRank())
              xRoot.Increment();
          }
       }
    }
    
    public Node Find(Node x){
      if(!x.GetParent().equals(x))
        x.SetParent(Find(x.GetParent()));
      return x.GetParent();
    }
    /*
     fonction MakeSet(x)
     x.parent := x
     x.rang   := 0
 
     fonction Union(x, y)
         xRacine := Find(x)
         yRacine := Find(y)
         si xRacine ≠ Racine
               si xRacine.rang < yRacine.rang
                  xRacine.parent := yRacine
               sinon
                  yRacine.parent := xRacine
                  si xRacine.rang == yRacine.rang
                    xRacine.rang := xRacine.rang + 1
                    
      fonction Find(x)
         si x.parent ≠ x
            x.parent := Find(x.parent)
         retourner x.parent
    */
} 
