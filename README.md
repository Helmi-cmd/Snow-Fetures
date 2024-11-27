README: Snow features Script
Overview
This script introduces a fun and interactive system for creating snowballs and snowmen in your environment, with dynamic features tied to the weather system. It enhances immersion and gameplay by allowing players to interact with snow in creative ways, including hiding inside a snowman for tactical or playful purposes.

Features
1. Snowball Creation
Players can create snowballs directly, provided the in-game weather conditions are appropriate (e.g., snowing or snowy ground).
Weather checks ensure snowball creation is realistic and immersive.

2. Snowman Construction
Players can use crafted snowballs to build a snowman.
A button or action trigger must be configured on the snowman item to initiate the construction process.
Once constructed, the snowman becomes a physical object in the game environment.

3. Hide in the Snowman
Players have the unique ability to "hide" inside the snowman after construction.
Hiding inside a snowman could provide strategic advantages (e.g., evading enemies or engaging in roleplay scenarios).

Requirements
Weather System Integration: The script relies on an active weather system that broadcasts or tracks current weather conditions.
Inventory Management: Players need an inventory system to store and manage snowballs.
Action Buttons: Customization is required to bind the "Build Snowman" action to a specific button or item trigger.
Setup Instructions


Integrate Script:

1. Configure Weather Check:
Ensure the script is tied to your weather system. Update any weather API keys or variable names to match your server's configuration.
2. Add Snowman Button:
In the item's metadata or interaction menu, bind a button to trigger the snowman creation function. Example:

buttons = {
				{
					label = 'Make a Snowman',
					close = true,
					action = function()
						TriggerEvent('qbx_smallresources:client:snowmanProgress', '')
						exports.ox_inventory:closeInventory()
					end
				},
			}

Test snowball creation in various weather conditions.
Verify snowman construction and ensure the "hide" feature works as intended.


Developer Notes
1. Customize weather conditions for snowball creation by editing the checkWeather() function.
2. Adjust the snowman model and animations in the script to fit your server's visual style.
3. Optional: Add cooldowns or limits to snowman construction to balance gameplay.

Example Usage
1. Create Snowball:
press assigned button to pick up snowman 
Checks if weather is snowy and adds a snowball to inventory.
2. Build Snowman:
 Select a snowball and press the assigned "Build" button.
A snowman appears in the game world.
3. Hide in Snowman:
Walk up to the snowman and interact with it to hide inside.


Known Issues
if Snowman dissapears/get destryed player stays inside.

Future Enhancements
Adding ability to check ground to prevent players from picking up snowballs inside.
Add animations snowman construction.
Introduce durability for snowmen that degrade over time or under specific conditions.
fixing snowman getting destroyed.

Enjoy the snowy fun!