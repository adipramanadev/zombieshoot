# Zombie Shooter Game (in development)

This is a simple **Zombie Shooter** game built using the **LÖVE (Love2D)** game framework. In this game, you control a player who must fend off waves of zombies using bullets. The player can move using the keyboard and shoot bullets using the mouse.

Although the game is still a work in progress, the basic mechanics are implemented, such as player movement, zombie spawning, and shooting.

## Features

- **Player Movement**: Move the player around the screen using WASD keys.
- **Zombie Spawning**: Press the "space" key to spawn zombies at random positions.
- **Shooting**: Click the mouse to spawn and shoot bullets toward the mouse pointer.
- **Zombie AI**: Zombies move toward the player to try and catch them.

## How to Run the Game

1. **Install LÖVE (Love2D)**:
   - You need the LÖVE framework to run this game. You can download and install it from the official website: [https://love2d.org/](https://love2d.org/).

2. **Clone or Download the Repository**:
   - Clone this repository using Git, or download the zip file and extract it to a folder.

3. **Run the Game**:
   - After installing LÖVE, navigate to the game folder in your terminal and run:
     ```
     love .
     ```
   - Alternatively, you can drag the folder onto the LÖVE executable to run it.

## Controls

- **WASD**: Move the player.
- **Mouse Click (Left Button)**: Shoot a bullet toward the mouse cursor.
- **Space**: Spawn a zombie.

## Game State

- The game is still in the early stages, and there is no scoring system or game over logic yet.
- Zombies are spawned when the player presses the "space" key, but they don’t yet pose a threat (there's no collision detection between the player and zombies, and no damage mechanics).

## Planned Features (Future Updates)

- **Collision Detection**: Detect when zombies collide with the player or bullets.
- **Health System**: The player will lose health when touched by zombies.
- **Score System**: Track and display the player's score based on zombie kills.
- **Game Over**: End the game when the player's health reaches zero or when certain conditions are met.
- **Sound Effects and Music**: Add sound effects for shooting, zombie death, and background music.



