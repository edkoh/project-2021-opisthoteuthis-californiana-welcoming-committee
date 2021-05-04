# __OCaml Tetris Writeup__

In this writeup, we will explain the functionality in each of the files, and then bring it all together and walk through the operation of the game!

Our Tetris implementation is split into six different files: Tetris, Model, Visualization, Tetrominoes, Controller, and Config. Tetris includes the main game loops; Model defines the `model` type and includes useful functions that operate on models; Visualization has functions to visualize the game; Tetrominoes defines both the square class and tetromino class; Controller defines a function that translates keystrokes into actions; and last but not least, Config stores config values that the rest of the game draws from.

<div style="text-align:center">
   <img src="./Visualization.png" width="400px">
</div>

---

## Model

One of the most important concepts in our implementation is the model. At any given time, our model stores the state of the board as a two dimensional matrix of booleans. Critically, it does not store the currently active piece. The model stores the
environment while the active piece is treated as the player in the environment. The model is only the stationary blocks. Once a piece reaches can no longer move, it is added to the model and a new one is created.

The model is a bool array array, with the row as the first array, the column. For example a given element is accessed with `m.(row).(column)`. It might seem counterintuitive to have the y element first, but it makes much more sense to access each row at a time than each column, especially when it comes to clearing lines.

## Tetrominos

Our first objective was to create a simplified version of Tetris that had no pieces, only single squares. Once we achieved this, we realized that we could represent tetrominoes as lists of squares! This is what we chose to do and believe that it works well.

### Square class

Each square object has a position x and y, a function to get and set the position, a function that returns the position of the moved square, and a function that adds that square to a model. Nothing too complex.

### Tetromino class

This is where the action happens. The only argument is an algebraic data type that stores all the pieces. The center for each piece is set to column 4, row 20. The initializer matches on the piece argument and creates the necessary squares.

In order to move the tetromino, first the moved positions are calculated as the variable `shifted`. Then those positions are checked against the model. If none of them intersect, then the shifted positions become the real positions and true is returned. In the case of NoAction or an intersection with the model, false is returned. In the case of a Drop, the piece is moved down until false is returned.

## Controller

Simple function checks if a key has been pressed and then matches the input with the corresponding action. If no key is pressed or if the key does not correspond to an action, NoAction is returned.

## Visualization

This is where all the gritty work happens drawing the board. Mostly self-explanatory, `draw_grid_lines` draws grid lines, and `fill_square` fills the given square. The `init_graph` function opens the graph and draws lines.

The `render_model` function takes a model and renders it with a double for loop. If the value in the model is true, it fills that square. `render_piece` iterates over each square in the piece and fills it. `render_text` takes a score and level and then renders the appropriate text along with the control instructions.

## Bringing it all together

## Tetris Gameplay

Enjoy! I had a lot of fun procrastinating other finals by “playtesting.”
