Design decisions
What we learned
How we carved it up
Maybe what we would do differently
Model-view-controller opinions?


# __OCaml Tetris Writeup__

Our Tetris implementation was primarily divided using the model–view–controller design. The “viewer” is written in `visualization.ml`, while the controller is written in `controller.ml`. Visualization encompasses the functions used to visualize the game, while Controller defines the functionality used for users to interact with it.

Due to the complexity of the game’s model, we further divided our model across three files: `tetris.ml`, `model.ml`, and `tetromino.ml`. Tetris includes the main game loops; Model defines the `model` type and associated functions; and Tetromino defines both the tetromino class and the square class of which tetrominoes are composed of.

A final Config file stores the initial configuration values and type definitions that the rest of the game draws from.

This overall structure of our project is visualized below
<div style="text-align:center">
   <img src="./Visualization.png" width="400px">
</div>

---

## Model

One of the most important concepts in our implementation is the model, which represents the playfield or “matrix”. At any given time, our model stores the state of the board in a two dimensional matrix of integers using the default OCaml `Array` type. This form was decided upon in order to most directly represent the different colors of displayed squares. Thus, the elements of the array are initially set to 0, the value representing an empty square, and as the game progresses, these 0’s are replaced by hex values of the color corresponding to the tetromino placed.

Critically, the model does not store the current active tetromino under the player’s control. Instead, the model stores the environment while the active tetromino is treated as an independent entity. In this way, manipulation of the active tetromino is streamlined and the model, which remains static for the duration of a single tetromino’s “lifespan”, is left unmodified for the said duration.

Another design decision in the implementation of the model was to define a model as an array of “rows”. The model was defined in such a way in order to facilitate the clearing of lines, which folds over each row.

### Additional functions

The `sq_full` function defined in `model.ml` simply takes in an `x`, `y` position and a model and returns whether the position is “occupied” in the model or is out of bounds. A single exception to this exists, however, where the function returns false if the piece is within the `x` boundaries but above the upper `y` boundary of the model. This was done in order to allow the piece to spawn on the 20th and 21st rows as per the standard tetris model - as well as a possible future implementation of a “vanish/buffer zone” (described here: https://harddrop.com/wiki/Playfield).

The `clear_lines` function takes a model as an argument and destructively clears lines (rows) that are fully occupied. After several attempts, we concluded that the most coherent and efficient way of clearing lines was by checking each row for the existence of an empty square, and if no empty squares exist, incrementing a `shift` counter (initially set to 0). The current and subsequent rows would then adopt rows `shift` positions up. Once this is complete, the top `shift` rows of the model are duplicated and thus the function finishes by setting the top `shift` rows to new arrays of empty squares. We lastly had the function return the final value of `shift` in order to have a basic scoring system.

## Tetromino

In our definitions of tetrominoes we decided to use classes in order to more concretely encompass and group the structure and functionality of tetrominoes. Moreover, as much of the functionality of different tetrominoes are shared, through sufficient abstraction we are able to efficiently define 7 subclasses of tetrominoes (the standard pieces).

In our initial development, we started with basic single block “squares” which could only translate and not rotate. In this class we originally included only a method for motion and an auxiliary method which returned whether an action was possible. However, upon considering the development of larger tetrominoes, we came upon the realization that characterizing tetrominoes by a list of `square`s would greatly simplify the movement and rotation of them.

### Square class

In the final result, each square object is initialized with `x` and `y` coordinates. Alongside functions for retrieving and setting the position as well as “adding” a square to a model, the `square` class additionally contains a `move` method which takes a center position and an action. For translations the method simply returns shifted coordinates; however, for rotations the method rotates the position about the given center by 90 degrees in either direction. Thus the rotation of a square gains significance and the `move` method may simply be called upon by the tetromino class without having to distinguish rotations from translations.

### Tetromino class

The `tetromino` class is

The only argument is an algebraic data type that stores all the pieces. The center for each piece is set to column 4, row 20. The initializer matches on the piece argument and creates the necessary squares.

In order to move the tetromino, first the moved positions are calculated as the variable `shifted`. Then those positions are checked against the model. If none of them intersect, then the shifted positions become the real positions and true is returned. In the case of NoAction or an intersection with the model, false is returned. In the case of a Drop, the piece is moved down until false is returned.

## Controller

Simple function checks if a key has been pressed and then matches the input with the corresponding action. If no key is pressed or if the key does not correspond to an action, NoAction is returned.

## Visualization

This is where all the gritty work happens drawing the board. Mostly self-explanatory, `draw_grid_lines` draws grid lines, and `fill_square` fills the given square. The `init_graph` function opens the graph and draws lines.

The `render_model` function takes a model and renders it with a double for loop. If the value in the model is true, it fills that square. `render_text` takes a score and level and then renders the appropriate text along with the control instructions.

## Config

## Bringing it all together

## Tetris Gameplay

Enjoy! I had a lot of fun procrastinating other finals by “playtesting.” Move with WASD and rotate with < and >. The game speeds up pretty quickly. Our highscores are 36 and 56 (Felix and Edward respectively).
