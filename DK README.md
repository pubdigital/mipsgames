Donkey Kong Game - MIPS Assembly

A simple Donkey Kong-style game implemented in MIPS assembly language for the MARS simulator.
Description

This project recreates a classic Donkey Kong-style platformer game where the player controls a blue character that must avoid red barrels while navigating platforms. The game features gravity physics, platform collision detection, and basic enemy AI.
Features

    Player Character: Blue square that can move left/right and jump

    Enemy Barrels: Red squares that move across platforms and fall when reaching edges

    Platform System: Multiple brown platforms at different heights

    Physics: Gravity and jumping mechanics with collision detection

    Game Over: When player collides with a barrel, screen flashes red

Controls

    W: Jump (only works when on ground)

    A: Move left

    D: Move right

Technical Requirements
MARS Simulator Setup

    Bitmap Display Configuration:

        Unit Width: 4

        Unit Height: 4

        Display Width: 256

        Display Height: 256

        Base Address: 0x10008000

    Keyboard and Display MMIO:

        Ensure Keyboard and Display MMIO Simulator is connected

        Address 0xffff0000 for keyboard input

Game Elements
Platforms

The game features 5 platforms at different heights:

    Platform 0: Top left (Y=8)

    Platform 1: Top right (Y=18)

    Platform 2: Middle left (Y=32)

    Platform 3: Middle right (Y=42)

    Platform 4: Bottom full width (Y=56)

Characters

    Player: 3x3 blue square

    Barrel: 3x3 red square

    Platforms: Brown horizontal lines

Game Mechanics
Physics

    Gravity: Objects accelerate downward when not on platforms

    Jumping: Player can jump with upward velocity when on ground

    Collision Detection: Precise platform collision for both player and barrels

Barrel Behavior

    Barrels move horizontally across platforms

    Barrels fall when they reach platform edges

    Barrels reset to starting position when they fall off screen

Code Structure
Main Data Sections

    Colors: Predefined color values (red, blue, brown, black, pink)

    Player State: Position, velocity, and ground status

    Barrel State: Position, velocity, and ground status

    Platform Data: Coordinates for all platforms

    Game State: Game over flag

Key Functions

    main: Main game loop

    clear_screen: Clears display to black

    apply_gravity: Handles gravity physics for player and barrels

    check_platform_collision: Detects platform collisions

    draw_player/draw_barrel: Render game objects

    check_input: Handles keyboard input

    check_collision: Detects player-barrel collisions
