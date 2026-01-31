# TODO List - GGJ 2026 Godot Conversion

## ✅ Completed

- [x] Setup project structure
- [x] Create project.godot configuration
- [x] Convert GameManager to GDScript
- [x] Convert ToolController base class
- [x] Convert MagnifyingGlassTool
- [x] Convert NPCQueueController
- [x] Convert MainMenuController
- [x] Convert ButtonHoverEffect
- [x] Convert SceneTransitionController
- [x] Convert EndingManager
- [x] Convert CutsceneController
- [x] Convert SettingsController
- [x] Create basic scenes (MainMenu, Gameplay)
- [x] Write documentation (README, Conversion Guide)

## 🚧 In Progress

- [ ] Import assets dari Unity project
- [ ] Create NPC scene/prefab
- [ ] Setup scene hierarchy untuk gameplay

## 📋 To Do

### High Priority
- [ ] Import sprites dari `Assets/Arts/`
- [ ] Import audio files
- [ ] Create GameManager autoload (singleton)
- [ ] Setup Input Map di Project Settings
- [ ] Create NPC character scene
- [ ] Create tool scenes (magnifying glass, dll)
- [ ] Implement gameplay logic

### Medium Priority
- [ ] Create settings scene dengan UI
- [ ] Create guide/tutorial scene
- [ ] Create cutscene scenes
- [ ] Create ending scenes (good, bad, neutral)
- [ ] Setup audio buses (Master, Music, SFX)
- [ ] Add button animations
- [ ] Add transition effects

### Low Priority
- [ ] Polish UI visual
- [ ] Add particle effects
- [ ] Add screen shake
- [ ] Optimize performance
- [ ] Add save/load system
- [ ] Create splash screen
- [ ] Add credits scene

## 🎯 Missing Components to Implement

### Dari Unity Project yang Belum Dikonversi:

1. **Audio System**
   - Audio Manager
   - Music looping
   - Sound effect pooling

2. **NPC System**
   - NPC character script
   - NPC dialogue system
   - NPC animation

3. **Tool System**
   - Implement all tools (selain magnifying glass)
   - Tool selection UI
   - Tool cursor system

4. **Game Flow**
   - Intro cutscene
   - Gameplay loop
   - Ending triggers
   - Win/lose conditions

5. **UI Polish**
   - Button animations
   - Menu transitions
   - Loading screens

## 📝 Notes

- Godot 4.3+ required
- All scripts converted to GDScript
- Using new Godot 4 syntax (signals, await, etc.)
- Project structure follows Godot best practices

## 🐛 Known Issues

- None yet - fresh conversion

## 💡 Ideas for Improvement

- Use Godot's built-in theme system untuk consistent UI
- Implement state machine dengan AnimationTree
- Use resource files untuk data (NPCs, tools, dll)
- Add gamepad support
- Add accessibility features
- Mobile support?

---

Last updated: January 31, 2026
