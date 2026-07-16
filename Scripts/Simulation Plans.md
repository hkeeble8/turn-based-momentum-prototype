## Movement / Position Architecture Summary

### Core split

* **Simulation owns logical movement state**

  * Is the entity moving?
  * Where is it going?
  * What is its current world position?
  * Can it interact with other entities?

* **Presentation owns movement execution**

  * TileMap pathfinding
  * Finding a path through cells
  * Animating sprites
  * Visual interpolation

---

## Entity state

A moving entity has:

```text
Company
 ├── PositionAspect
 │      world_position: Vector2
 │
 └── MovementAspect
        moving: bool
        destination: Vector2
```

The simulation knows:

```
Company A:
    position = (100, 200)
    moving = true
    destination = (500, 600)
```

It does **not** know:

* which tiles it crossed
* which animation is playing
* how many frames it took

---

## Movement start flow

```
Entity decides:
    "I want to move"

        |
        v

MoveCommand(entity, destination)

        |
        v

Simulation processes command

        |
        v

Simulation adds MovementAspect

        |
        v

Emit MovementStarted event

        |
        v

Presentation starts pathfinding + animation
```

---

## While moving

Presentation:

* moves the sprite
* follows the TileMap path

Simulation:

* knows entity is moving
* stores the latest logical position

---

## Position updates

Because presentation controls actual movement:

```
Presentation
    |
    | PositionUpdated(entity_id, world_position)
    v
Simulation
```

The simulation updates:

```gdscript
entity.position = new_position
```

---

## How often send positions?

Do **not** send every frame.

Preferred options:

### Active movers only

```
Company A moving:
    send updates

Settlement:
    no updates
```

---

### Fixed simulation steps

Example:

```
Simulation step:
    Request current positions

Presentation:
    Send positions of moving entities

Simulation:
    Run AI / decisions
```

---

### Important events

Send updates when:

* entity starts moving
* entity arrives
* entity enters a new area
* entity gets close to another entity

---

## Distance queries

Because simulation has positions:

```gdscript
distance = company_a.position.distance_to(company_b.position)
```

It can answer:

* nearest company
* nearest settlement
* within attack range
* encounter detection

---

## Important rule

The simulation should **not ask the presentation where things are every time it needs to know**.

Instead:

* Presentation reports movement progress.
* Simulation stores the latest known logical position.
* Simulation uses that state for decisions.

The presentation is the "movement executor"; the simulation is the "world authority".
