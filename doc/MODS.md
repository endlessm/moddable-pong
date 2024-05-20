# Available modifications

## Challenge

## Core Mechanics

### Gradual increase of ball speed during gameplay

Select the `GameLogicVersus` node from the Scene Dock. In the Inspector,
adjust the `Ball Velocity Multiplier` to have a value above 1. The ball will
now increase its velocity every time it hits a paddle.

## Rules

## Space

Try replacing the `BasicSpace` node in the Scene Dock by removing it
and then instantiating the `GalaxySpace` scene. What about
instantiating the `TrapScene` instead? Make sure the space is below
paddles or balls, otherwise they will be occluded by the space
background.

## Components

Try changing the position, rotation or scale of the paddles from the
canvas.

Try adding more paddles to either side by duplicating the nodes in the
Scene Dock and then moving them in the canvas. You can change the side
of the paddle from the Inspector `player` property. What about playing with
5 balls at the same time?

Try adding other kinds of paddles or balls by instantiating
them. Click the *Instantiate Child Scene* button in the Scene Dock,
then search for "paddle". Or you can use the Filesystem Dock, then
find the scene files like `res://components/balls/banana_ball.tscn`
and then drag them into the canvas.


Try changing properties of the nodes, like the initial speed of balls
and paddles, the initial direction of the ball.