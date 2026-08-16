# <span style="color: #E63946;">CPC Drive Suite - NeckFX Backend</span> 🏎️

<span style="color: #000000;">**Version:** 3.0.0</span>  
<span style="color: #000000;">**Author:** Dmitrii Alekseev / creed / Codex</span>  
<span style="color: #E63946;">**Purpose:** Advanced 6DOF camera backend for immersive first-person driving experience in Assetto Corsa</span>

---

## <span style="color: #E63946;">Overview</span>

The <span style="color: #000000;">**CPC Drive Suite NeckFX Backend**</span> is a sophisticated head tracking and dynamic camera movement system that enhances immersion in Assetto Corsa by simulating realistic head motion and camera positioning. This mod creates a physically realistic response to vehicle dynamics, making cockpit-view driving significantly more lifelike.

---

## <span style="color: #E63946;">Key Features</span>

### <span style="color: #E63946;">🎯 6-Axis Dynamic Movement</span>
The system simulates full six-degree-of-freedom (6DOF) movement:
- <span style="color: #000000;">**3 Positional Axes:** Lateral (X), Vertical (Y), and Forward/Backward (Z) head movement</span>
- <span style="color: #000000;">**3 Rotational Axes:** Yaw (horizontal), Pitch (vertical tilt), and Roll (lateral tilt)</span>
- <span style="color: #000000;">Fully customizable movement distance and response speed for each axis</span>

### <span style="color: #E63946;">📍 Direction Following System</span>
- <span style="color: #000000;">**Slide Following:** Head leans into direction changes as the car slides or turns</span>
- <span style="color: #000000;">**Track Following:** Camera looks ahead along the race line using track spline data</span>
- <span style="color: #000000;">**Steering Following:** Head position responds to steering input</span>
- <span style="color: #000000;">**Adjustable lookahead distance:** Set how far ahead the camera looks (10-40 meters)</span>

### <span style="color: #E63946;">🚗 G-Force Responsive Movement</span>
- <span style="color: #000000;">**Dynamic Movement:** Camera movement intensity scales with vehicle acceleration</span>
- <span style="color: #000000;">**Speed Scaling:** Effects intensify at higher speeds with customizable speed caps</span>
- <span style="color: #000000;">**G-Force Mapping:** Full movement effects activate at configurable G-force thresholds (0.5-4.0 G)</span>

### <span style="color: #E63946;">🎪 Advanced Rotation Systems</span>

#### <span style="color: #E63946;">Primary Rotations</span>
- <span style="color: #000000;">**Yaw:** Responds to steering and track trajectory</span>
- <span style="color: #000000;">**Pitch:** Reacts to braking and acceleration forces</span>
- <span style="color: #000000;">**Roll:** Responds to lateral G-forces during cornering</span>

#### <span style="color: #E63946;">Drift-Specific Motion</span>
- <span style="color: #000000;">**Drift Yaw:** Extra head rotation during vehicle slip and drift conditions</span>
- <span style="color: #000000;">Independent speed control for responsive drift feedback</span>

#### <span style="color: #E63946;">Road Surface Effects</span>
- <span style="color: #000000;">**Road Pitch:** Camera follows elevation changes and road slopes</span>
- <span style="color: #000000;">**Bank Roll:** Responds to track banking and vehicle body attitude</span>

#### <span style="color: #E63946;">Speed-Dependent Effects</span>
- <span style="color: #000000;">**Speed Pitch:** High-speed aerodynamic pitch effect</span>
- <span style="color: #000000;">**Speed Yaw:** Trajectory-based yaw at speed</span>
- <span style="color: #000000;">**Speed Roll:** Corner lean intensity at speed</span>
- <span style="color: #000000;">Progressive activation between configurable speed thresholds</span>

### <span style="color: #E63946;">🔄 Subtle Transient Movements</span>
The "Hidden" features add micro-movements for realism:
- <span style="color: #000000;">**Hidden Jerk Response:** Pitch and roll from acceleration changes</span>
- <span style="color: #000000;">**Hidden Yaw Lag:** Subtle neck lag during rapid car rotation</span>
- <span style="color: #000000;">**Hidden Transient Angles:** Barely perceptible movements that subconsciously enhance immersion</span>

### <span style="color: #E63946;">🎚️ Advanced Motion Blending</span>
Eight independent interpolation mixes allow complex motion interactions:
- <span style="color: #000000;">Mix between different axes (Yaw↔Roll, Pitch↔Roll, etc.)</span>
- <span style="color: #000000;">Cross-axis effects create natural, physical head movement patterns</span>
- <span style="color: #000000;">Fine-tune how different motion types influence each other</span>

---

## <span style="color: #E63946;">Customization Options</span>

### <span style="color: #E63946;">Movement Control</span>
All settings are <span style="color: #E63946;">**fully customizable**</span> through the in-game CPC Drive Suite app:

| <span style="color: #E63946;">Setting</span> | <span style="color: #E63946;">Range</span> | <span style="color: #000000;">Purpose</span> |
|---------|-------|---------|
| <span style="color: #000000;">**Overall Speed Multiplier**</span> | <span style="color: #000000;">0.1 - 3.0×</span> | <span style="color: #000000;">Master control for all motion effects</span> |
| <span style="color: #000000;">**G-Force at Full**</span> | <span style="color: #000000;">0.5 - 4.0 G</span> | <span style="color: #000000;">Acceleration threshold for full movement</span> |
| <span style="color: #000000;">**Effect Speed Cap**</span> | <span style="color: #000000;">1 - 200 km/h</span> | <span style="color: #000000;">Speed where movement effects reach maximum</span> |
| <span style="color: #000000;">**Lateral Movement (X)**</span> | <span style="color: #000000;">0 - 0.15 m</span> | <span style="color: #000000;">Maximum left/right head travel</span> |
| <span style="color: #000000;">**Vertical Movement (Y)**</span> | <span style="color: #000000;">0 - 0.10 m</span> | <span style="color: #000000;">Maximum up/down head travel</span> |
| <span style="color: #000000;">**Forward/Back Movement (Z)**</span> | <span style="color: #000000;">0 - 0.15 m</span> | <span style="color: #000000;">Maximum forward/backward head travel</span> |
| <span style="color: #000000;">**Yaw/Pitch/Roll Angles**</span> | <span style="color: #000000;">0 - 45°</span> | <span style="color: #000000;">Maximum rotation angles (all individually tunable)</span> |
| <span style="color: #000000;">**Response Speeds**</span> | <span style="color: #000000;">0.5 - 30</span> | <span style="color: #000000;">How quickly camera follows vehicle dynamics</span> |

### <span style="color: #E63946;">Track-Specific Parameters</span>
- <span style="color: #000000;">**Slide Following:** 0-100% intensity</span>
- <span style="color: #000000;">**Track Following Lookahead:** 10-40 meters ahead</span>
- <span style="color: #000000;">**Steering Sensitivity:** 0 - 2.0 multiplier</span>
- <span style="color: #000000;">**Track Following Blend:** 0.3 - 1.0 intensity</span>

---

## <span style="color: #E63946;">How It Works</span>

1. <span style="color: #E63946;">**Real-Time Physics Monitoring:**</span> <span style="color: #000000;">The system continuously reads vehicle telemetry including:</span>
   - <span style="color: #000000;">Acceleration forces (all axes)</span>
   - <span style="color: #000000;">Steering input and vehicle yaw rate</span>
   - <span style="color: #000000;">Vehicle speed</span>
   - <span style="color: #000000;">Track geometry and banking</span>
   - <span style="color: #000000;">Slip and drift detection</span>

2. <span style="color: #E63946;">**Dynamic Calculation:**</span> <span style="color: #000000;">Position and rotation are calculated using:</span>
   - <span style="color: #000000;">Exponential smoothing for natural motion curves</span>
   - <span style="color: #000000;">Configurable response lags for each axis</span>
   - <span style="color: #000000;">Speed-dependent effect scaling</span>
   - <span style="color: #000000;">Multi-axis interaction mixing</span>

3. <span style="color: #E63946;">**Synchronized Playback:**</span> <span style="color: #000000;">Camera movements are smoothly applied in real-time, synchronized with the racing simulation</span>

---

## <span style="color: #E63946;">Installation</span>

1. <span style="color: #000000;">Place the `extension/lua/cockpit-camera/` folder in your Assetto Corsa CSP (Content Manager with Custom Shaders Patch) extensions directory</span>
2. <span style="color: #000000;">Place the `apps/lua/cpc_drive_suite/` folder in your apps directory</span>
3. <span style="color: #000000;">Restart Assetto Corsa</span>
4. <span style="color: #000000;">Open the CPC Drive Suite app in-game to configure settings</span>

---

## <span style="color: #E63946;">In-Game Control</span>

The <span style="color: #E63946;">**CPC Drive Suite app**</span> provides a live interface for:
- <span style="color: #000000;">✅ Enable/Disable the NeckFX system</span>
- <span style="color: #000000;">🎚️ Real-time adjustment of all 50+ parameters</span>
- <span style="color: #000000;">📊 Visual feedback of active effects</span>
- <span style="color: #000000;">💾 Automatic setting saves</span>

<span style="color: #000000;">Changes apply immediately without restarting—perfect for dialing in your perfect camera feel.</span>

---

## <span style="color: #E63946;">App UI Demo</span>

<video width="100%" controls>
  <source src="app-ui-demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

<span style="color: #000000;">Watch the CPC Drive Suite app in action with live parameter adjustment and real-time camera effect feedback.</span>

---

## <span style="color: #E63946;">Technical Specifications</span>

- <span style="color: #000000;">**Configuration Storage:** Shared between app and backend via `cpc-drive-suite-v1` storage path</span>
- <span style="color: #000000;">**Script Context:** Runs in CSP's dedicated cockpit-camera script context</span>
- <span style="color: #000000;">**Update Rate:** Synchronized with simulation tick rate</span>
- <span style="color: #000000;">**Compatibility:** Requires CSP (Custom Shaders Patch) for Assetto Corsa</span>

---

## <span style="color: #E63946;">Performance Impact</span>

<span style="color: #000000;">Minimal CPU overhead due to efficient Lua implementation and direct integration with CSP's camera system. Effects are calculated only during active gameplay.</span>

---

## <span style="color: #E63946;">Tips for Best Results</span>

1. <span style="color: #000000;">**Start with Defaults:** The default settings are expertly tuned for realistic motion</span>
2. <span style="color: #000000;">**Adjust Overall Speed First:** Use the master multiplier to increase/decrease intensity globally</span>
3. <span style="color: #000000;">**Fine-Tune by Category:** Adjust position and rotation separately, then tweak individual effects</span>
4. <span style="color: #000000;">**Test Different Cars:** Different vehicles may benefit from slightly different settings</span>
5. <span style="color: #000000;">**Use Track Following:** Enables more immersive cornering with predictive camera movement</span>

---

## <span style="color: #E63946;">Credits</span>

<span style="color: #000000;">**Created by:** Dmitrii Alekseev (creed / Codex)</span>  
<span style="color: #E63946;">**Technology:** 6DOF camera motion physics for Assetto Corsa with CSP</span>

---

<span style="color: #E63946;">**Enjoy the most immersive first-person driving experience in Assetto Corsa!**</span> 🏁
