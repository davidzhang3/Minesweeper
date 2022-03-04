import de.bezier.guido.*;
private final static int NUM_ROWS = 12;
private final static int NUM_COLS = 12;
private final static int NUM_MINES = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int a = 0; a < NUM_COLS; a++) {
      buttons[i][a] = new MSButton(i, a);
    }
  }

  setMines();
}
public void setMines()
{
  while (mines.size() < NUM_MINES) {
    int row = (int)(Math.random()*(NUM_ROWS));
    int col = (int)(Math.random()*(NUM_COLS));
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
    exit();
  }
}
public boolean isWon()
{ 
  int count = 0;
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int a = 0; a < NUM_COLS; a++) {
      if (mines.contains(buttons[i][a]) && buttons[i][a].isFlagged()) {
        count++;
      }
    }
  }
  if (count == NUM_MINES) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int a = 0; a < NUM_COLS; a++) {
      buttons[i][a].setLabel("LOSE");
    }
  }
}
public void displayWinningMessage()
{
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int a = 0; a < NUM_COLS; a++) {
      buttons[i][a].setLabel("WIN");
    }
  }
}
public boolean isValid(int r, int c)
{
  if (r > NUM_ROWS - 1 || r < 0) {
    return false;
  }
  if (c > NUM_COLS - 1 || c < 0) {
    return false;
  }
  return true;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row - 1; i <= row + 1; i++) {
    for (int a = col - 1; a <= col + 1; a++) {
      if (isValid(i, a) && mines.contains(buttons[i][a])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
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
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      for (int i = 0; i < NUM_ROWS; i++) {
        for (int a = 0; a < NUM_COLS; a++) {
          if (!buttons[i][a].isClicked()) {
            buttons[i][a].clicked = true;
          }
        }
      }
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      myLabel = "" + countMines(myRow, myCol);
    } else {
      for (int i = myRow - 1; i <= myRow + 1; i++) {
        for (int a = myCol - 1; a <= myCol + 1; a++) {
          if (isValid(i, a) && !buttons[i][a].isClicked()) {
            buttons[i][a].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
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
  public boolean isClicked() {
    return clicked;
  }
}
