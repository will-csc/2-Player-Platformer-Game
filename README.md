# 2 Player Platformer Game

A local co-op 2D platformer built with Godot 4.5.

In this project, two players must move through platforming levels together, collect fruit, avoid hazards, and reach the flag to advance. The game uses a shared co-op camera and a tether system so both players stay close and progress as a team.

## Overview

## Features

- Local 2-player platformer gameplay
- Three playable levels
- Shared co-op camera centered between both players
- Distance limit between players so one cannot leave the other behind
- Fruit collection with separate scores for each player
- Exit flag system that tracks each player individually
- Full game reset back to Level 1 when a player falls past the final death line in Level 3

## Controls

### Player 1

- Move left: `A`
- Move right: `D`
- Jump: `W`

### Player 2

- Move left: `Left Arrow`
- Move right: `Right Arrow`
- Jump: `Up Arrow`

## How Progression Works

- A level is completed only after both players reach the flag
- The players do not need to stand on the flag at the same time
- When one player reaches the flag, that player is marked as finished
- When the second player reaches the flag, the game loads the next level
- In Level 3, falling below the death line resets both scores and restarts the game from Level 1

## Tech Stack

- Godot 4.5
- GDScript

## Project Structure

```text
scenes/    Main levels
prefebs/   Reusable scene prefabs
scripts/   Gameplay logic
sprites/   Game art and UI assets
fonts/     Fonts used in the HUD
```

## How to Run

1. Open the project in Godot 4.5
2. Load the folder as a Godot project
3. Press Play in the editor

The game starts from:

```text
res://scenes/level_1.tscn
```

## Main Gameplay Scripts

- `scripts/Global.gd` handles shared score, co-op camera behavior, player tethering, and the Level 3 restart logic
- `scripts/flag.gd` controls level completion and next-level loading
- `scripts/fruit.gd` handles fruit collection and score updates
- `scripts/player1.gd` and `scripts/player2.gd` control player movement and death behavior

## Repository Notes

- This project is focused on cooperative gameplay
- Most mechanics are scene-driven and implemented with reusable prefabs and lightweight scripts
- The current setup is intended for local play on one keyboard
