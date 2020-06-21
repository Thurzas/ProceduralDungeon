import java.util.ArrayList;
import java.util.Comparator;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import processing.core.PApplet;
import processing.core.PVector;
public class WorldGrid{
    public PVector size;
    public ArrayList<Cell> Nodes;    
    public boolean[][] visited;

    private static class XComparator implements Comparator<Cell> {
      /*public int compare(Object o1, Object o2) {
        return compare((PVector)o1,(PVector)o2);
      }*/
      public int compare(Cell p1, Cell p2) {
        if (p1.CellPos.x < p2.CellPos.x) {
          return -1;
        }
        else if (p1.CellPos.x > p2.CellPos.x) {
          return 1;
        }
        else {
          return 0;
        }
      }
    }
    
    public WorldGrid( PVector size){
        this.size = new PVector((int)(size.x/Cell.CellSize), (int)(size.y/Cell.CellSize)); 
        Nodes = new ArrayList<Cell>();
        System.out.println(size.x);
        for(int i =0;i<this.size.x;i++){
          for(int j =0;  j<this.size.y;j++)
            Nodes.add(new Cell(new PVector(i,j)));          
        }
        visited = new boolean[(int)size.x][(int)size.y];
        System.out.println(visited.length);
    }
    public void print(ArrayList<PVector> points, int value){
      for(PVector point : points){
         Cell c = GetNode(point);
         if(c!=null)
           c.Value=value;
      }
    }
  
    public Cell GetNode(PVector coords)
    {
        for (Cell node : Nodes)
        {
            if(node.CellPos.x==coords.x && node.CellPos.y==coords.y)
            {
                return node;
            }
        }
        return null;
    }


    public boolean ContainsCoords(PVector coords)
    {
        boolean b = false;

        for(Cell node : Nodes)
        {
            if (node.CellPos == coords)
                b = true;
        }

        return b;
    }

    public ArrayList<Cell> GetNodeList()
    {
        return Nodes;
    }
}
