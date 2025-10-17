# Atlas Explorer

<p align="center">
  <img src="https://i.imgur.com/g7nxrYs.png" alt="Atlas Explorer Logo" width="240">
</p>

[![License: Custom](https://img.shields.io/badge/license-Custom-blue.svg)]()
[![Version](https://img.shields.io/badge/version-0.1--alpha-orange.svg)]()
[![Made for Roblox](https://img.shields.io/badge/platform-Roblox-lightgrey.svg)]()


**Atlas Explorer** is an advanced in-game developer suite for Roblox — built to help creators visualize, debug, and optimize their games *directly inside the live environment*.  

It provides real-time insights into your workspace, performance, and scripts with the goal of becoming the **must-have tool for all Roblox developers**.

---

## 🚀 Overview

Atlas Explorer acts as a multi-panel diagnostic and inspection utility that extends the Roblox experience with developer-grade tools.  
Think of it as a hybrid between **Roblox Studio’s Explorer** and **Unity’s Profiler**, but accessible *in-game* and *runtime-aware*.

Key capabilities include:

- 🔍 **Live Instance Explorer** — browse and manipulate the DataModel in real time.  
- ⚙️ **Property Inspector** — edit and monitor instance properties dynamically.  
- 🧠 **Debug Utilities** — visualize object lifecycles, detect leaks, and inspect UI Z-order and layout issues.  
- ⚡ **Performance Metrics** — monitor frame time, memory, network throughput, and garbage collection.  
- 📡 **Remote Traffic Tools** *(optional)* — track server/client RemoteEvent and RemoteFunction usage for debugging replication and latency.  
- 🧩 **Extendable Architecture** — add custom modules for your own game systems or debugging workflows.

---

## 🧩 Module Structure

Atlas Explorer is organized into modular services, making it easy to extend or disable features.

| Module | Description |
|--------|--------------|
| `APIService` | Core reflection and data interface that communicates with Roblox’s internal API dump to identify class members, instantiable objects, and property metadata. Enables smart filtering for the Object Browser and ensures accurate object creation and validation. |
| `AtlasClipboard` | Handles cut, copy, paste, and duplication operations within the Explorer. Keeps a consistent clipboard state across multiple selections and ensures correct parenting and hierarchy replication. |
| `AtlasContextMenu` | Responsible for right-click context interactions within the Explorer tree. Dynamically generates context actions such as Delete, Duplicate, Cut, Paste, Expand/Collapse All, Select Children, and Insert Object. |
| `AtlasCore` | The root manager of the entire Atlas system. Handles initialization, inter-module communication, UI mounting, and lifecycle management. Essentially the brain of the Atlas Explorer runtime. |
| `AtlasDrag` | Manages drag-and-drop operations within the Explorer. Handles ghost rendering, selection updates, and smooth positional tracking for accurate instance reordering or reparenting. |
| `AtlasIcons` | Centralized icon library for representing Roblox instance types (e.g., Model, Part, Script). Icons are dynamically assigned and used throughout both the Explorer and Object Browser UIs. |
| `AtlasId` | Provides unique, consistent identifiers for instances within the Explorer. Used internally for selection tracking, drag synchronization, and cross-module reference integrity. |
| `AtlasObjectBrowser` | The searchable creation UI for inserting new Roblox objects. Integrates with `APIService` to display all instantiable classes, allows live filtering, hover and selection effects, and instantiates chosen objects directly into selected parents. |
| `AtlasProperties` | Handles the properties panel and value editor. Responsible for displaying, modifying, and syncing instance property data between Roblox and Atlas in real time. |
| `AtlasTree` | The backbone of the Explorer window — responsible for rendering, updating, and managing the hierarchical instance tree. Handles selection, multi-selection, hover effects, collapse/expand logic, scrolling behavior, and live syncing with the DataModel. |

> Each module is sandboxed and uses a lightweight signal/event pipeline to minimize overhead and improve modularity.

---

## 🔧 Developer Features (Planned / In Progress)

| Category               | Feature                                   | Status         |
| ---------------------- | ----------------------------------------- | -------------- |
| **Core Debug**         | Instance Explorer + Properties Panel      | ✅             |
| **Performance Tools**  | FPS/Memory/Network overlay                | 🔄 In Progress |
| **Timeline Logger**    | Property/event tracking over time         | 🔄 In Progress |
| **Remote Monitor**     | Bandwidth & latency diagnostics           | 🔄 In Progress |
| **UI Inspector**       | Z-Index & layout debugging                | 🧠 Planned     |
| **Snapshot Diff Tool** | Compare workspace states                  | 🧠 Planned     |
| **Leak Detection**     | Object lifecycle & instance count diffing | 🧠 Planned     |

---

## 🧠 Philosophy

Atlas Explorer was designed around three pillars:

**1. Transparency** — expose what’s really happening in your game. 
**2. Control** — empower developers to fix and optimize issues on the fly. 
**3. Extensibility** — serve as a foundation for future debugging and visualization tools. 

This project isn’t just for convenience — it’s about making *runtime diagnostics accessible to every Roblox developer*.

---

## 📜 License & Attribution

All code and assets in this repository are **© Bykhovsky**, unless otherwise stated.
You are free to **use, modify, and integrate** this project in your own Roblox creations,
but **you may not claim ownership or original authorship** of the Atlas Explorer system.

If you use Atlas in your own projects, please include visible credit or a repository reference.

*(Custom licensing terms may be added later if Atlas evolves into a standalone toolkit.)*

---

## 🧩 Contributing

Contributions are welcome!
If you’d like to propose new debugging modules or performance analysis ideas:

1. Fork the repo
2. Create a feature branch
3. Submit a pull request with documentation and reasoning

---

## 💬 Contact

For collaboration, feedback, or licensing inquiries, reach out via:  
Roblox DevForum: [Bykhovsky](https://devforum.roblox.com/u/bykhovsky/summary)  
Discord Profile: [Bykhovsky](https://discordapp.com/users/878344368795295744)  
