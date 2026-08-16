# CPC Drive Suite

CPC Drive Suite combines the former Adaptive Wheel Clutch, CPC Throttle Camera
and CPC Dynamic 6DOF controller into one CSP Lua app. It also includes a
resizable, custom-drawn telemetry HUD.

Version 3.0.1 uses CSP shared memory for live NeckFX settings, backend status
and 6DOF output telemetry so the separate camera runtime connects immediately.

## Included systems

- Adaptive launch, predictive anti-stall, shift clutching and optional drift
  clutch kicks. A physical clutch pedal always retains priority.
- Throttle-shaped FOV, adjustable starting seat pose, five motion axes, speed
  scaling and position/angle/speed-to-FOV mixes.
- Live control of the matching CPC Drive Suite NeckFX backend: X/Y/Z movement,
  yaw/pitch/roll, drift/road/banking layers, high-speed angles, transient neck
  lag, non-recursive mixes and direction following.
- Full, inputs-focused and minimal HUD layouts with selectable color theme,
  opacity, units, animation strength and individually hidden HUD sections.

## First use

1. Enable **CPC Drive Suite** in CSP Lua apps and open it from the in-game app
   shelf.
2. In CSP NeckFX, select **CPC Drive Suite - NeckFX Backend**, enable scripted
   NeckFX and reload the driving session. The Home page should show `ONLINE`.
3. Disable Assetto Corsa's built-in auto-clutch if using the clutch assist.
4. Disable other apps which directly change onboard seat position or FOV.
   NeckFX is compatible because it runs as a separate camera layer.
5. Start with the Road or Speed G-Force preset and test at low speed.

Every setting saves automatically. Right-click any slider to reset only that
value. Reset buttons are provided separately for each subsystem.
