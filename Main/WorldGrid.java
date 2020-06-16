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
    public WorldGrid(ArrayList<Cell> nodes, PVector size)
    {
        this.size = new PVector(size.x/Cell.CellSize, size.y/Cell.CellSize);
        Nodes = nodes;
        Collections.sort(Nodes, new XComparator());
    }
    
    public WorldGrid( PVector size){
        this.size = new PVector((int)(size.x/Cell.CellSize), (int)(size.y/Cell.CellSize)); 
        Nodes = new ArrayList<Cell>();
        
        for(int i =0;i<size.x;i++){
          for(int j =0;  j<size.y;j++)
            Nodes.add(new Cell(new PVector(i,j)));          
        }     
    }
    public void print(ArrayList<PVector> points, int value){
      for(PVector point : points){
         Cell c = GetNode(point); 
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
