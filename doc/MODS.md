# Available modifications

## Challenge

### Customising scoring

Select the `GameLogic` node from the Scene Dock. In the Inspector, you
will now see several properties (such as `Scoring on Left Goal`) which
you can use to adjust the scoring mechanism. With these controls you can
convert the game to a cooperative survival mode, gain points via collisions
with paddles or obstacles, etc.

## Core Mechanics

### Gradual increase of ball speed during gameplay

Select the `GameLogic` node from the Scene Dock. In the Inspector
under `Ball Properties`, adjust the `Ball Velocity Multiplier` to have
a value above 1. The ball will now increase its velocity every time it
hits a paddle. What about changing the `Ball Size Multiplier` instead?
Which value makes the game easier and which makes it harder?

## Rules

### Allow the paddles to move left and right

Select any `BasicPaddle` node from the Scene Dock. In the Inspector,
turn the `Tennis Movement` property on to allow the paddle to move left and
right in addition to up/down.

## Space

### Change the background

Select the `BasicSpace` node from the Scene Dock. You
can change the background by dragging in an image file from the FileSystem
view on top of the `Background Texture` property in the Inspector.

The `Background Repeatable` property controls whether the texture is tiled or
scaled to fill the game space.

### Alternative game space

In the Scene Dock, right click the `BasicSpace` node and click
`Delete Node(s)`.

Right click the `Main` node in the Scene Dock, select
`Instantiate Child Scene` and instantiate the `spaces/galaxy_space.tscn`
scene.

Next, in the Scene Dock, drag the new `GalaxySpace` up to the top of the list
of nodes within `Main` (this prevents the balls and paddles being occluded by
the background).

Now you have an alternate game space with black holes and asteroids.

Repeat the above with the `spaces/trap_space.tscn` scene for an alternate
game space with moving walls.

### Change the user interface

The information of a game is usually in a layer called HUD. Select the
`HUD` node in the Scene Dock. Then you can change the color, the font
size or the typography.

## Components

### Adjusting paddle or ball profile

Select the `BasicPaddleLeft` or `BasicPaddleRight` node from the Scene Dock.
Now you can drag the paddle within the 2D canvas to adjust its position.
On the Canvas toolbar, you can select the `Rotate Mode` or `Scale Mode` tools
and then dragging the paddle will adjust its rotation or scale.

You can do the same with the ball (`BasicBall` node).

### Changing paddle and ball textures

Select `BasicPaddleLeft` or `BasicPaddleRight` in the Scene Dock.
In the FileSystem Dock, browse to `res://assets/textures/paddles`.
Drag one of the alternative paddle images over to the `Texture` property in
the Inspector. You can also recolor the paddle by adjusting the `Tint`
property.

The ball texture can be customised the same way, by selecting the `BasicBall`
node and using alternative textures from `res://assets/textures/balls`.

You can also import images to the Filesystem Dock by dragging them
from your system. Then you can use your own images as textures. Can
you take a selfie and then use it as the paddle texture?

### Changing paddle speed

Click on the `BasicPaddleLeft` or `BasicPaddleRight` node. In the inspector,
you will see the `Speed` property which you can adjust.

### Ball size, speed and direction

Click the `BasicBall` node in the Scene Dock. In the Inspector, you can
now adjust the ball's Size, Initial Speed, and Initial Direction.

### Adding more paddles and balls

In the Scene Dock, right click on `BasicPaddleLeft` and click Duplicate.
You now have two left paddles on top of each other. In the 2D canvas, drag
one of the paddles to a new location.

The same process can be applied to `BasicPaddleRight`, and you can even
play with multiple balls by duplicating `BasicBall`.

### Elastic paddles

Right click the `Main` node in the Scene Dock, select
`Instantiate Child Scene` and instantiate the
`components/paddles/elastic_paddle.tscn` scene. Now you have a paddle that
will stretch as it moves. You may wish to drag to reposition the
`ElasticPaddle` in the 2D canvas and delete the original `BasicPaddle`.

Click on the `ElasticPaddle`, and you will then see several properties
available in the inspector, where you can assign it to a specific player
(Left/Right), and adjust its Max Length, Speed, Enlarge Speed and Shrink
Speed.

### Change ball type

Right click the `BallSpawner` node in the Scene Dock, select
`Instantiate Child Scene`, and instantiate the
`components/balls/banana_ball.tscn` scene. Now you have a spinning
banana ball.  You may wish to drag to reposition the
`BananaBall` in the 2D canvas and delete the original `BasicBall`.

### Asteroids and vortexes

Right click the `Main` node in the Scene Dock, select
`Instantiate Child Scene`, and instantiate the
`components/other/asteroid.tscn` scene. Drag the Asteroid within the 2D
canvas to an appropriate position. This acts as an obstacle for the ball.

Repeat the same for the `components/other/vortex.tscn`. This gives you
a vortex that will adjust the speed and angle of the ball as it passes
through.
