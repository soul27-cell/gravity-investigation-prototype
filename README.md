# Gravity Investigation Prototype

A small educational prototype for investigating gravitational force in a virtual physics experiment.

## Play the game

1. Open Godot 4.x.
2. Open this folder as a project.
3. Press F5 or click Run.

## Research focus

This prototype allows students to:
- predict the effect of changing mass or distance
- run a virtual gravitational experiment
- collect trial data
- observe a simple graph
- compare predictions with results

## Main formula

F = GMm / r²

All calculations use SI units internally.

## Project structure

- `scripts/PhysicsCalculator.gd` — gravitational calculations
- `scripts/UnitConverter.gd` — SI conversion helpers
- `scripts/TrialRecord.gd` — trial record data object
- `scripts/TrialHistory.gd` — trial storage
- `scripts/SpaceView.gd` — visual representation of two objects
- `scripts/GraphPanel.gd` — experimental graph drawing
- `scripts/MainScene.gd` — main gameplay and logic
- `scenes/MainScene.tscn` — playable scene
