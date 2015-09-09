# Tic Tac Toe

This is a normal game of tic tac toe that can be played by any combination of humans or computers, although two computers is pretty boring, since it plays out the same every time. The computer player currently uses a minimax algorithm with alpha beta pruning to choose its moves - next on the chopping block is to implement an alternative "heuristic" minimax algorithm capable of evaluating intermediate board states, along with an arbitrary cut-off, which will make playing with larger-than-standard game boards more feasible. 

### Classes

- **Game:** Runs the game, taking care of setup, the turn loop, and game end.
- **Board:** Manages the state and behavior of the game board, as well as supporting a variety of useful queries.
- **CommandLineInterface:** Implements all the functionality necessary to play the game over the command line.
- **Player:** Handles getting moves from any kind of player - also styled as a class interface with functionality coming from other classes.
- **HumanPlayer:** Implements functionality necessary to get a valid move from a human player.
- **ComputerPlayer:** Implements functionality necessary to generate a move for a computer player.

### Scripts

- *tictactoe.rb* - Runs one game when executed.

### Issues

- Not a problem per se, but in some cases the computer will choose to make a fork rather than immediately selecting a winning move. This is because Enumerable#max_by simply returns the first max value in a collection when there are multiple maximum values present. If you want to reproduce this: 1st player = human, 2nd player = computer, as human move at [0,0], [2,2], [0,1]. Notice how if you move at [0,0], [0,2], [0,1] instead, since the fork is not possible, the computer wins immediately rather than blocking you. For comparison, if you move at [1,1], [2,2], [1,2] the computer could choose to make a fork by next moving at [1,0], but it wins immediately by moving at [0,1] instead.
