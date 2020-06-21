
import java.lang.Math; 
import processing.core.PVector;
import java.util.ArrayList;
import java.lang.Math;
public class Edge implements Comparable<Edge>{
  
  public PVector p1, p2;
  public float size;
  
  public Edge() {
    p1=null;
    p2=null;
    size=0;
  }
  
  public Edge(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    size=(float)Math.sqrt(Math.pow(p2.x-p1.x,2f)+Math.pow(p2.y-p1.y,2f));
  }  
  
  public int compareTo(Edge other){
    if(size<other.size)
      return -1; 
    
    if(size>other.size)
      return 1; 
    
    else
      return 0;
  }     
  
  public ArrayList<PVector> print(){
/*     ArrayList<PVector> points = new ArrayList<PVector>();
  
     int x1 =Math.round(p1.x/Cell.CellSize)-1;
     int x2 =Math.round(p2.x/Cell.CellSize);
     int y1 =Math.round(p1.y/Cell.CellSize)-1;
     int y2 =Math.round(p2.y/Cell.CellSize);
     int dx,dy,e;
     e=x2-x1;  
     dx=e*2;
     dy=(y2-y1)*2;
     
     while(x1<x2)
     {
       PVector p = new PVector(x1,y1);
       
       points.add(p);
       e -= dy;
       if(e<=0)
       {
         y1++;
         e+=dx;
       }
       x1++;
     }
     return points;
*/

     ArrayList<PVector> points = new ArrayList<PVector>();
    
     int x1 =Math.round(p1.x/Cell.CellSize-0.5f)-1;
     int x2 =Math.round(p2.x/Cell.CellSize);
     int y1 =Math.round(p1.y/Cell.CellSize-0.5f)-1;
     int y2 =Math.round(p2.y/Cell.CellSize);
     int dx,dy,e;
      
     dx=x2-x1;
     dy=y2-y1;
     if(dx!=0)
     {
      if(dx>0)
      {
       if(dy!=0)
       {
         if( dy>0)
         {
           //valeur oblique dans le premier quadran.
           if(dx>=dy)
           {           
             //Vecteur diagonal ou oblique proche de l'horizontale, dans le premier octant
             e=dx;
             dy*=2;
             dx*=2;
             while(x1<x2) // boucle horizontale
             {
               points.add(new PVector(x1,y1));
               e-=dy;
               if(e<0)
               {
                y1++;
                points.add(new PVector(x1,y1));
                e+=dx;
               }
               x1++;
             }
           }       
           else //oblique proche de la vertical du 2em octant
            {    
              e=dy;
              dy*=2;
              dx*=2;
              while(y1<y2) // boucle  verticale
              {                
                points.add(new PVector(x1,y1));
                e-=dx;
                if(e<0)
                {
                 x1++;
                 points.add(new PVector(x1,y1));
                 e+=dy;
                }
                y1++;
              }        
            }         
         }
         else // dy<0 et dx >0
         {
           if(dx>=-dy) // diagonal ou oblique proche de l'horizontale du 8° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1<x2) //horizontal
             {             
               points.add(new PVector(x1,y1));
               e+=dy;
               if(e<0)
               {
                 y1--;
                 points.add(new PVector(x1,y1));
                 e+=dx;
               }
               x1++;
             }
           }
           else //vecteur oblique proche de la verticale, 7em octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>y2) //vertical
             {             
               points.add(new PVector(x1,y1));
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                 points.add(new PVector(x1,y1));
                 e+=dy;
               }
               y1--;
             }           
           }
         }
       }
       else // dy == 0
       {
         while(x1<x2)
         {
           points.add(new PVector(x1,y1));
           x1++;
         }         
       }
     }
     else //dx < 0
     {
       dy=y2-y1;
       if(dy!=0)
       {
         if(dy>0) // oblique 2° quadran
         {
           if(-dx>=dy) //diagonal ou oblique proche de l'horizontale du 4° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>x2){ //horizontal
               points.add(new PVector(x1,y1));
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                 points.add(new PVector(x1,y1));
                 e+=dx;
               }
               x1--;
             }
           }
           else //oblique proche de la vertical du 3° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1<y2){
               points.add(new PVector(x1,y1));
               e+=dx;
               if(e<=0)
               {
                 x1--;
                 points.add(new PVector(x1,y1));
                 e+=dy;
               }
               y1++;
             }             
           }
         }
         else //dy < 0 et dx <0
         {
           if(dx<=dy) // 5°octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>x2) //horizontal
             {
               points.add(new PVector(x1,y1));
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                 points.add(new PVector(x1,y1));
                 e+=dx;
               }
               x1--;
             }
           }
           else //6° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>y2){
               points.add(new PVector(x1,y1));
               e-=dx;
               if(e>=0)
               {
                 x1--;
                 points.add(new PVector(x1,y1));
                 e+=dy;
               }
               y1--;
             }
           }
         }         
       }
       else //dy = 0 et dx <0
       {
         while(x1<x2)
         {
           points.add(new PVector(x1,y1));
           x1--;           
         }
       }
     }
   }
   else
   {
     dy=y2-y1;
     if(dy!=0)
     {
       if(dy>0)
       {
         while(y1<y2)
         {
           points.add(new PVector(x1,y1));
           y1++;
         }
       }
       else
       {
         while(y1>y2)
         {
           points.add(new PVector(x1,y1));
           y1--;
         }
       }
      }
   }
   return points;   
 }   
  
  
  public boolean isOpposite(Edge e){
    if(e.p1==p2 && e.p2==p1)
      return true;
    else
      return false;
  }
  
  public Edge GetOpposite(){
   return new Edge(p2,p1);    
  }
  

  @Override
  public boolean equals(Object a){
    boolean res= false;
    if(a!=null)
    {        
      if(a instanceof Edge)
      {     
        Edge other = (Edge)a;
        res =(p1.x == other.p1.x && p2.x == other.p2.x && p1.y == other.p1.y && p2.y == other.p2.y);
      }
    }
    return res;    
  }
}
  /*
  @Override
  public String toString()
  {
     return "Edge : "+p1.toString()+", "+p2.toString()+" size :"+size;     
  }*/
