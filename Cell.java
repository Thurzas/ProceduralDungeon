import java.util.ArrayList;
import java.util.Comparator;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import processing.core.PApplet;
import processing.core.PVector;

public class Cell {
    public PVector CellPos;
    public ArrayList<PVector> Neighbors;
    public Cell parent;
    public static int CellSize = 10;
    public int Value;
    public Cell( PVector cellPos)
    {
        this.CellPos = cellPos;
        Value=0;
    }    
}
