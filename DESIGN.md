This document is a brain dump on rules and current design.

**TODO**
- Add gravel block
- Add monster sprite
- Add monster AI

### Tiles
Tiles will be split up into 3 distinct layers:

#### Layer 1
- Floor
- Dirt
- Water
- Spies
- Conveyor blocks
- Help
- Home

NOTE: Everything above layer 1 should probably be an entity that we convert at load time.

#### Layer 2
- Chips
- Keys
- Boots
- Motherboard
- Buttons (Green & Blue)
- Teleport portals
- Blocks that close once you walk through them?

#### Layer 3
- Wall?
- Monsters
- Moveable blocks
- Breakable blocks
