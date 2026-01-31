# Magnifier Cursor Debug Checklist

## Status Check
- ✅ Fixed: Duplicate `_deactivate_magnifier()` function in magnifying_glass_tool.gd
- ✅ Fixed: Invalid enum in button_hover_effect.gd line 33 (changed `layout_mode = 1` to `layout_mode = Control.LayoutMode.CONTAINER`)
- ✅ Fixed: Invalid UID for audio asset in main_menu.tscn (removed uid for SFX Click1.ogg)
- ✅ Created: magnifier_cursor.tscn scene with shader and viewport
- ✅ Integrated: MagnifierUI into gameplay.tscn

## Testing Steps

### Step 1: Reload Godot Project
1. Save changes in VS Code
2. Return to Godot Editor
3. Press `Ctrl+Shift+F5` to force reimport all assets (optional but recommended)
4. Wait for project to finish importing

### Step 2: Check Console for Errors
When you start the game:
1. Open Godot Console (View → Output)
2. Look for `=== MagnifierHandler _ready() START ===` message
3. Verify these debug messages appear in order:
   - `=== MagnifierHandler _ready() START ===`
   - `>> Setting up magnifier viewport...`
   - `>> Looking for parent button...`
   - `>> Parent type: TextureButton`
   - `>> Parent name: KacaPembesar`
   - `>> Parent is TextureButton, connecting signal...`
   - `>> Signal connected!`
   - `=== MagnifierHandler _ready() END ===`

### Step 3: Test Magnifier Activation
1. Run game (F5)
2. Look for the glasses button (KacaPembesar) in the UI
3. Click the glasses button
4. Look in console for: `[BUTTON CLICK] KacaPembesar clicked!`
5. Verify magnifier appears on screen

### Step 4: Verify Zoom Effect
1. Move mouse around while magnifier is active
2. Magnifier should follow cursor
3. Lens area should show zoomed version of scene at 2.5x magnification
4. Scene inside lens should move as you move mouse (tracking cursor position)

### Step 5: Test Deactivation
1. Click glasses button again to deactivate
2. Magnifier should disappear
3. Console should show: `[DEACTIVATE] Magnifier deactivated!`

## Troubleshooting

### If console shows errors:

**Error: "magnifier_ui group not found"**
- Check that MagnifierUI node is in gameplay.tscn
- Verify it has "magnifier_ui" group assigned in Node panel

**Error: "Parent is not a TextureButton"**
- Check that MagnifierHandler script is attached to Meja > KacaPembesar button
- Verify KacaPembesar is TextureButton type

**Error: "magnifier_viewport is null"**
- Check magnifier_cursor.tscn exists at correct path
- Verify SubViewport is named "MagnifierViewport"
- Check that MagnifierUI scene is properly instanced

**Error: "magnifier_camera is null"**
- Verify Camera2D node exists in MagnifierViewport
- Ensure Camera2D is named "MagnifierCamera"
- Check zoom is set to Vector2(0.4, 0.4)

### If magnifier doesn't show:

1. Check if `magnifier_viewport.visible = true` is being called
2. Verify SubViewport has `render_target_update_mode = UPDATE_WHEN_VISIBLE` (mode 4)
3. Check if MagnifierUI is properly positioned
4. Verify shader is applied to MagnifierDisplay TextureRect

### If zoom isn't working:

1. Check camera zoom calculation: `1.0 / zoom_factor` = `1.0 / 2.5` = `0.4`
2. If zoom too strong: increase zoom_factor (default 2.5)
3. If zoom too weak: decrease zoom_factor
4. Adjust `zoom_level` uniform in shader (range 0.5 to 3.0)

## File Changes Summary

```
MODIFIED:
- scripts/tools/magnifying_glass_tool.gd (removed duplicate function)
- scripts/ui/button_hover_effect.gd (fixed enum - already done)
- scenes/ui/main_menu.tscn (removed invalid UID)

CREATED:
- scenes/tools/magnifier_cursor.tscn (new magnifier scene)

SCENE SETUP:
- gameplay.tscn: Added MagnifierUI instance with "magnifier_ui" group
- gameplay.tscn: KacaPembesar > MagnifierHandler with magnifying_glass_tool.gd
```

## Next Actions if Still Not Working

1. **Enable verbose logging** in magnifying_glass_tool.gd (already has print statements)
2. **Check scene tree** in Godot editor:
   - Open gameplay.tscn
   - Look for MagnifierUI node with "magnifier_ui" group
   - Verify it has MagnifierViewport and MagnifierCamera children
3. **Manual viewport test**:
   - Create simple test scene with SubViewport
   - Verify SubViewport renders content
   - Test shader material separately
4. **Signal connection test**:
   - Add `print()` calls in button click handler
   - Verify TextureButton.pressed signal is being triggered

## Expected Final Result

✅ Click glasses button → Magnifier cursor appears
✅ Move mouse → Lens follows cursor position
✅ See zoomed scene content inside lens circle
✅ Click again → Magnifier disappears
✅ All debug console messages appear in correct order
