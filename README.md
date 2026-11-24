Farm Management Simulator
Farm Management Simulator is a Roblox game built for the Pinnacle 1 Game Design Project. Grow and sell crops during the day, then defend the farm from zombies at night. Every purchase is a choice between expanding the farm and preparing for the next attack.
How to play
1. Visit the seed shop and buy seeds for wheat, carrots, tomatoes, or peach trees. Use the seed pouch to choose a crop and check your stock.
2. Plant and water your crops. Watch their growth indicators and use pesticide when a pest warning appears.
3. Harvest and sell mature crops. Use the earnings to buy supplies and combat equipment or to repair the fence.
4. At night, monitor the fence health and defend the farm. If zombies breach the fence, they can reach the crops.
The HUD shows cash, XP, level, time, weather, and fence health. The game's design sets a retirement goal of $25,000 in game cash.
Run the game locally
1. Clone or download this repository.
2. Open the Roblox place file (.rbxl or .rbxlx) in Roblox Studio.
3. Start a playtest. Try buying seeds, planting a crop, and watching the farm as day becomes night.
You can play the core Roblox game without the Arduino setup.
How it works
The game uses Luau in Roblox Studio. Client scripts handle player input and the HUD. Server scripts manage shared state such as cash, crop growth, and fence health. RemoteEvents carry player requests and game updates between them.
Arduino soil-moisture input
The team wrote Arduino code to read a soil-moisture sensor. The goal is to use a real moisture reading as an input for crop care in Roblox. The wiring, method for sending readings to Roblox, and live in-game response still need to be documented or verified.
Gameplay checks
The project recording shows a successful seed purchase, an insufficient cash message on a second attempt, crop growth and pest indicators, a $15 zombie bounty, and fence damage during a night encounter.
Team contributions
Member	Contributions
Shahid	Weather and day/night systems, fence health, zombie attacks on the fence and crops, shop and seed pouch UI, error messages, and default values
Vihaan	Crop growth, buying and selling crops, pesticide system, harvesting tools, and Arduino soil-moisture input code
Priyaansh	Map, story sequence, cash system, lanterns, plant models, shop setup, XP and levels, and harvesting tools
Rishabh	Zombie combat weapons, armour, testing, diagnostics, bug finding, and quality-of-life improvements
Jaiveer	Game time, early crop progression, initial cash system, and Arduino equipment support
