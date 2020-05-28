import de.bezier.guido.*;
public final static int NUM_ROWS= 10;
public final static int NUM_COLS= 10;
public final int NUM_MINES= 15;
private MSButton[][] buttons;//2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
 
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
  buttons=new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0;r<NUM_ROWS;r++){
    for (int c=0;c<NUM_COLS;c++){
       buttons[r][c] = new MSButton(r,c);     
    }
  }  
    setMines();
}
public void setMines()
{
  int row,col;
  
    for (int i=0;i<NUM_MINES;i++){
      row=(int)(Math.random()*NUM_ROWS);
      col=(int)(Math.random()*NUM_COLS);
      if (!mines.contains(buttons[row][col])){ 
        mines.add(buttons[row][col]);
           //System.out.println(row+","+col);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
   for (int i=0;i<mines.size();i++){
     if (mines.get(i).flagged==false){
       return false;
     }
   }
    return true;
}
public void displayLosingMessage()
{
    for (int i=0;i<mines.size();i++){
      mines.get(i).clicked=true;
    }
    for (int r=0;r<NUM_ROWS;r++){
      for (int c=0;c<NUM_COLS;c++){
        if (!mines.contains(buttons[r][c])){
          buttons[r][c].clicked=true;
        }
      }
    }
    text("YOU LOSE :(", CENTER, CENTER);
    
}
public void displayWinningMessage()
{
    // textAlign(CENTER,CENTER);
    text("YOU WIN!! :D",CENTER,CENTER);
}

public boolean isValid(int r, int c)
{
  return r<NUM_ROWS && c<NUM_COLS && r>=0 && c>=0;
}
public int countMines(int row, int col)
{
    int numMines = 0;
   for (int r=row-1;r<=row+1;r++){
     for (int c=col-1;c<=col+1;c++){
       if (isValid(r,c) && mines.contains(buttons[r][c])){
         numMines++;
      }
     }
   }
        return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton==RIGHT){
          if (flagged==true){
            flagged=false;
            clicked=false;
          }else if (flagged==false){
            flagged=true;
          }
        }else if (mines.contains(this)){
          displayLosingMessage();
        }else if (countMines(this.myRow,this.myCol)>0){
          setLabel(""+countMines(this.myRow,this.myCol));
        }else{
          for (int r=myRow-1;r<=myRow+1;r++){
             for (int c=myCol-1;c<=myCol+1;c++){
               if (isValid(r,c) && buttons[r][c].clicked==false && !(r==myRow && c==myCol)){
                    buttons[r][c].mousePressed();
                }
             }      
         }
       }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
