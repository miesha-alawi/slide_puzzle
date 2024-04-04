PImage source;
int cols = 4;
int rows = 4;
Tile[] tiles = new Tile[cols*rows];
int[] board = new int[cols*rows];
String[] pictures;
int w, h;

void setup() {
  size(400, 400);
  pictures = loadStrings("list.txt");
  String src = pictures[floor(random(0,pictures.length))];
  source = loadImage(src);
  source.resize(width, height);
  w = width/cols;
  h = height/rows;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * w;
      int y = j * h;
      PImage img = createImage(w, h, RGB);
      img.copy(source, x, y, w, h, 0, 0, w, h);
      int index = i+j*cols;
      board[index] = index;
      Tile tile = new Tile(index, img);
      tiles[index] = tile;
    }
  }

  tiles[tiles.length-1] = null;
  board[board.length-1] = -1;
  shuffle(board);
}

void randomMove(int[] arr) {
  int r1 = floor(random(cols));
  int r2 = floor(random(rows));
  move(r1, r2, arr);
}

void shuffle(int[] arr) {
  for (int i = 0; i < 1000; i++) {
    randomMove(arr);
  }
}

void move(int i, int j, int[] arr) {
  int blank = findBlank();
  int blankCol = blank % cols;
  int blankRow = floor(blank / rows);

  if (isNeighbor(i, j, blankCol, blankRow)) {
    swap(blank, i+j*cols, arr);
  }
}

boolean isNeighbor(int i, int j, int x, int y) {
  //either same col or row
  if (i != x && j != y) {
    return false;
  }
  //one spot away
  if (abs(i-x) == 1 || abs(j-y) ==1) {
    return true;
  } else {
    return false;
  }
}

void swap(int i, int j, int[] arr) {
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

int findBlank() {
  int blank = 0;
  for (int i = 0; i < board.length; i++) {
    if (board[i] == -1) {
      blank = i;
    }
  }
  return blank;
}

boolean isSolved() {
  boolean verdict = true;
  for(int i = 0; i < board.length-1; i++) {
    if(board[i] != tiles[i].index) {
      verdict = false;
    }
  }
  return verdict;
}

void mousePressed() {
  int col = floor(mouseX/w);
  int row = floor(mouseY/h);
  move(col,row,board);
}

void draw() {
  background(200);
  if(isSolved()) {
    println("SOLVED!");
  }
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int index = i + j * cols;
      int x = i*w;
      int y = j*h;
      int tileIndex = board[index];
      if (tileIndex >= 0) {
        PImage img = tiles[tileIndex].img;
        image(img, x, y, w-2, h-2);
      }
    }
  }
}
