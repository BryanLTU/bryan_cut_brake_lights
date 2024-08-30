# BryaN Cut Brake Lights

## Description

Simple script that creates a usable item to cut the brake lights of a vehicle. Since the car brake's will not be visible, it will be more difficult for other players (etc. racers, police officers) to notice when you're braking and making a turn.

## Setup

In ``config.lua`` set the required values

### Inventory
Which inventory to use
- esx
- qb-core
- ox
```lua
Config.Inventory = 'ox'
```

### Item
Desired item's name
```lua
Config.Item = 'pliers'
```

If you're using ox_inventory, you can paste the provided item below to the ``ox_inventory/data/items.lua`` configuration
```lua
['pliers'] = {
    label = 'Pliers',
    weight = 50,
    consume = 0.3,
    close = true,
    client = {
        event = 'bryan_cut_brake_lights:client:cutBrakes'
    }
}
```