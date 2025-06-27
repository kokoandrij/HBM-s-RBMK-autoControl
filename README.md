🧪 RBMK Reactor Control System for HBM's Nuclear Tech Mod
This is a Lua script designed for use with the OpenComputers mod in Minecraft 1.7.10. It provides monitoring and automated safety control for RBMK reactors from HBM's Nuclear Tech Mod, helping to prevent meltdowns and unsafe operating conditions.

⚙️ Features:
✅ Monitors fuel rod status

✅ Reads values from fluid gauges (for steam/water monitoring)

✅ Integrates with Geiger counters to track radiation

✅ Collects information from energy storage units

✅ Supports boiler integration for additional safety

✅ Basic UI/text feedback for current system status

✅ Automatic reactor shutdown logic (optional)

📦 Requirements:
-Minecraft 1.7.10
-HBM's Nuclear Tech Mod
-OpenComputers

Components:
-Server Rack:

![image](https://github.com/user-attachments/assets/906eab8c-fa60-41d9-9583-21f5a83f50a6)

🛠️ Installation
Place the script inside your OpenComputers computer (via pastebin, floppy disk, or manual input).
Make sure all reactor components are connected to the computer using cables.
Boot the server and run the script.

🔧 Tip: You can set the script to autorun by placing it in the /home/autorun.lua file on OpenOS.

🔐 Safety Features
-Monitors coolant and steam levels to avoid dry boil
-Detects dangerous conditions and can automatically shut down the reactor
-Basic fault tolerance (dependent on component response time)


🧑‍💻 Configuration
You can configure values directly in-game:
Safe temperature threshold

📸 Screenshots:
![image](https://github.com/user-attachments/assets/3941a03f-20e7-4a8a-ae5b-1b6fda633243)

![image](https://github.com/user-attachments/assets/948bdc70-3a40-4af3-b213-0b8c76562db9)

![image](https://github.com/user-attachments/assets/5f7da927-e9fe-4fe0-8244-ab4ac5526875)

📜 License:
MIT License. Use, modify, and share freely — but give credit where due!

❤️ Credits:
Made with uranium and love by KokoAndrii
Inspired by Chernobyl memes and a desire to not vaporize your Minecraft base.
