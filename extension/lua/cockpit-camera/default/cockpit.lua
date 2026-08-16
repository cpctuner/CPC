-- CPC Drive Suite 3.0.1 - NeckFX backend
-- CSP runs cockpit-camera scripts in a separate context, so this file shares
-- one storage path with apps/lua/cpc_drive_suite/cpc_drive_suite.lua.

local scriptSettings = ac.INIConfig.scriptSettings()
local cfg = scriptSettings:mapSection('SETTINGS', {
  DYNAMIC_MOVEMENT = 1,
  OVERALL_SPEED = 1.0,
  G_FORCE_AT_FULL = 1.5,
  EFFECT_SPEED_CAP = 20,
  EFFECT_SPEED_CAP_MPH = 0,
  MOVE_X_DISTANCE = 0.035,
  MOVE_X_SPEED = 9,
  MOVE_Y_DISTANCE = 0.015,
  MOVE_Y_SPEED = 12,
  MOVE_Z_DISTANCE = 0.040,
  MOVE_Z_SPEED = 9,
  YAW_ANGLE = 10,
  YAW_SPEED = 8,
  PITCH_ANGLE = 8,
  PITCH_SPEED = 9,
  ROLL_ANGLE = 10,
  ROLL_SPEED = 9,
  DRIFT_YAW_ANGLE = 12,
  DRIFT_YAW_SPEED = 9,
  ROAD_PITCH_ANGLE = 8,
  ROAD_PITCH_SPEED = 7,
  BANK_ROLL_ANGLE = 10,
  BANK_ROLL_SPEED = 8,
  SPEED_ANGLE_START_KMH = 20,
  SPEED_ANGLE_FULL_KMH = 180,
  SPEED_PITCH_ANGLE = 5,
  SPEED_PITCH_SPEED = 6,
  SPEED_YAW_ANGLE = 8,
  SPEED_YAW_SPEED = 8,
  SPEED_ROLL_ANGLE = 8,
  SPEED_ROLL_SPEED = 8,
  HIDDEN_JERK_AT_FULL = 8,
  HIDDEN_YAW_RATE_AT_FULL = 1.0,
  HIDDEN_YAW_ANGLE = 3,
  HIDDEN_YAW_SPEED = 12,
  HIDDEN_PITCH_ANGLE = 2.5,
  HIDDEN_PITCH_SPEED = 14,
  HIDDEN_ROLL_ANGLE = 3,
  HIDDEN_ROLL_SPEED = 14,
  MIX_YAW_TO_ROLL = 0.20,
  MIX_ROLL_TO_YAW = 0.10,
  MIX_PITCH_TO_ROLL = 0.05,
  MIX_ROLL_TO_PITCH = 0.10,
  MIX_X_TO_Z = 0.15,
  MIX_Z_TO_X = 0.10,
  MIX_Y_TO_Z = 0.15,
  MIX_Z_TO_Y = 0.20,
  SLIDE_FOLLOWING = 1,
  SLIDING_LOOK_MULT = 0.5,
  TRACK_FOLLOWING = 1,
  TRACK_FOLLOWING_MULT = 0.7,
  STEERING_MULT = 0.7,
  LOOKAHEAD_DISTANCE = 20
})

ac.storageSetPath('cpc-drive-suite-v1')
local live = ac.storage({
  suiteEnabled = true,
  neckEnabled = true,
  neckDynamicMovement = cfg.DYNAMIC_MOVEMENT ~= 0,
  neckOverallSpeed = cfg.OVERALL_SPEED,
  neckGForceAtFull = cfg.G_FORCE_AT_FULL,
  neckEffectSpeedCap = cfg.EFFECT_SPEED_CAP,
  neckEffectSpeedCapMph = cfg.EFFECT_SPEED_CAP_MPH ~= 0,
  neckMoveXDistance = cfg.MOVE_X_DISTANCE,
  neckMoveXSpeed = cfg.MOVE_X_SPEED,
  neckMoveYDistance = cfg.MOVE_Y_DISTANCE,
  neckMoveYSpeed = cfg.MOVE_Y_SPEED,
  neckMoveZDistance = cfg.MOVE_Z_DISTANCE,
  neckMoveZSpeed = cfg.MOVE_Z_SPEED,
  neckYawAngle = cfg.YAW_ANGLE,
  neckYawSpeed = cfg.YAW_SPEED,
  neckPitchAngle = cfg.PITCH_ANGLE,
  neckPitchSpeed = cfg.PITCH_SPEED,
  neckRollAngle = cfg.ROLL_ANGLE,
  neckRollSpeed = cfg.ROLL_SPEED,
  neckDriftYawAngle = cfg.DRIFT_YAW_ANGLE,
  neckDriftYawSpeed = cfg.DRIFT_YAW_SPEED,
  neckRoadPitchAngle = cfg.ROAD_PITCH_ANGLE,
  neckRoadPitchSpeed = cfg.ROAD_PITCH_SPEED,
  neckBankRollAngle = cfg.BANK_ROLL_ANGLE,
  neckBankRollSpeed = cfg.BANK_ROLL_SPEED,
  neckSpeedAngleStartKmh = cfg.SPEED_ANGLE_START_KMH,
  neckSpeedAngleFullKmh = cfg.SPEED_ANGLE_FULL_KMH,
  neckSpeedPitchAngle = cfg.SPEED_PITCH_ANGLE,
  neckSpeedPitchSpeed = cfg.SPEED_PITCH_SPEED,
  neckSpeedYawAngle = cfg.SPEED_YAW_ANGLE,
  neckSpeedYawSpeed = cfg.SPEED_YAW_SPEED,
  neckSpeedRollAngle = cfg.SPEED_ROLL_ANGLE,
  neckSpeedRollSpeed = cfg.SPEED_ROLL_SPEED,
  neckHiddenJerkAtFull = cfg.HIDDEN_JERK_AT_FULL,
  neckHiddenYawRateAtFull = cfg.HIDDEN_YAW_RATE_AT_FULL,
  neckHiddenYawAngle = cfg.HIDDEN_YAW_ANGLE,
  neckHiddenYawSpeed = cfg.HIDDEN_YAW_SPEED,
  neckHiddenPitchAngle = cfg.HIDDEN_PITCH_ANGLE,
  neckHiddenPitchSpeed = cfg.HIDDEN_PITCH_SPEED,
  neckHiddenRollAngle = cfg.HIDDEN_ROLL_ANGLE,
  neckHiddenRollSpeed = cfg.HIDDEN_ROLL_SPEED,
  neckMixYawToRoll = cfg.MIX_YAW_TO_ROLL,
  neckMixRollToYaw = cfg.MIX_ROLL_TO_YAW,
  neckMixPitchToRoll = cfg.MIX_PITCH_TO_ROLL,
  neckMixRollToPitch = cfg.MIX_ROLL_TO_PITCH,
  neckMixXToZ = cfg.MIX_X_TO_Z,
  neckMixZToX = cfg.MIX_Z_TO_X,
  neckMixYToZ = cfg.MIX_Y_TO_Z,
  neckMixZToY = cfg.MIX_Z_TO_Y,
  neckSlideFollowing = cfg.SLIDE_FOLLOWING ~= 0,
  neckSlidingLookMult = cfg.SLIDING_LOOK_MULT,
  neckTrackFollowing = cfg.TRACK_FOLLOWING ~= 0,
  neckTrackFollowingMult = cfg.TRACK_FOLLOWING_MULT,
  neckSteeringMult = cfg.STEERING_MULT,
  neckLookaheadDistance = cfg.LOOKAHEAD_DISTANCE,
  neckHeartbeat = 0,
  neckEffectStrength = 0,
  neckOutputX = 0,
  neckOutputY = 0,
  neckOutputZ = 0,
  neckOutputYaw = 0,
  neckOutputPitch = 0,
  neckOutputRoll = 0
})

local neckLink = ac.connect({
  ac.StructItem.key('cpc.drive.suite.neckfx.v2'),
  appSequence = ac.StructItem.uint32(),
  backendSequence = ac.StructItem.uint32(),
  backendPresent = ac.StructItem.boolean(),
  suiteEnabled = ac.StructItem.boolean(),
  neckEnabled = ac.StructItem.boolean(),
  neckDynamicMovement = ac.StructItem.boolean(),
  neckOverallSpeed = ac.StructItem.float(),
  neckGForceAtFull = ac.StructItem.float(),
  neckEffectSpeedCap = ac.StructItem.float(),
  neckEffectSpeedCapMph = ac.StructItem.boolean(),
  neckMoveXDistance = ac.StructItem.float(),
  neckMoveXSpeed = ac.StructItem.float(),
  neckMoveYDistance = ac.StructItem.float(),
  neckMoveYSpeed = ac.StructItem.float(),
  neckMoveZDistance = ac.StructItem.float(),
  neckMoveZSpeed = ac.StructItem.float(),
  neckYawAngle = ac.StructItem.float(),
  neckYawSpeed = ac.StructItem.float(),
  neckPitchAngle = ac.StructItem.float(),
  neckPitchSpeed = ac.StructItem.float(),
  neckRollAngle = ac.StructItem.float(),
  neckRollSpeed = ac.StructItem.float(),
  neckDriftYawAngle = ac.StructItem.float(),
  neckDriftYawSpeed = ac.StructItem.float(),
  neckRoadPitchAngle = ac.StructItem.float(),
  neckRoadPitchSpeed = ac.StructItem.float(),
  neckBankRollAngle = ac.StructItem.float(),
  neckBankRollSpeed = ac.StructItem.float(),
  neckSpeedAngleStartKmh = ac.StructItem.float(),
  neckSpeedAngleFullKmh = ac.StructItem.float(),
  neckSpeedPitchAngle = ac.StructItem.float(),
  neckSpeedPitchSpeed = ac.StructItem.float(),
  neckSpeedYawAngle = ac.StructItem.float(),
  neckSpeedYawSpeed = ac.StructItem.float(),
  neckSpeedRollAngle = ac.StructItem.float(),
  neckSpeedRollSpeed = ac.StructItem.float(),
  neckHiddenJerkAtFull = ac.StructItem.float(),
  neckHiddenYawRateAtFull = ac.StructItem.float(),
  neckHiddenYawAngle = ac.StructItem.float(),
  neckHiddenYawSpeed = ac.StructItem.float(),
  neckHiddenPitchAngle = ac.StructItem.float(),
  neckHiddenPitchSpeed = ac.StructItem.float(),
  neckHiddenRollAngle = ac.StructItem.float(),
  neckHiddenRollSpeed = ac.StructItem.float(),
  neckMixYawToRoll = ac.StructItem.float(),
  neckMixRollToYaw = ac.StructItem.float(),
  neckMixPitchToRoll = ac.StructItem.float(),
  neckMixRollToPitch = ac.StructItem.float(),
  neckMixXToZ = ac.StructItem.float(),
  neckMixZToX = ac.StructItem.float(),
  neckMixYToZ = ac.StructItem.float(),
  neckMixZToY = ac.StructItem.float(),
  neckSlideFollowing = ac.StructItem.boolean(),
  neckSlidingLookMult = ac.StructItem.float(),
  neckTrackFollowing = ac.StructItem.boolean(),
  neckTrackFollowingMult = ac.StructItem.float(),
  neckSteeringMult = ac.StructItem.float(),
  neckLookaheadDistance = ac.StructItem.float(),
  neckEffectStrength = ac.StructItem.float(),
  neckOutputX = ac.StructItem.float(),
  neckOutputY = ac.StructItem.float(),
  neckOutputZ = ac.StructItem.float(),
  neckOutputYaw = ac.StructItem.float(),
  neckOutputPitch = ac.StructItem.float(),
  neckOutputRoll = ac.StructItem.float()
}, true, ac.SharedNamespace.Global)

-- All persistent values originate in the app. From this point the existing
-- motion code reads and writes the live connection without changing its logic.
live = neckLink

local turnHead, driftState, angleMult = 0, 1, 0
local steerSmooth, targetAngle, lastAngle, steerSpeed = 0, 0, 0, 1
local lookAheadX, lookAheadY, lookAheadBlend = 0, 0, 0
local moveX, moveY, moveZ = 0, 0, 0
local dynamicYaw, dynamicPitch, dynamicRoll = 0, 0, 0
local driftYaw, roadPitch, bankRoll = 0, 0, 0
local speedPitch, speedYaw, speedRoll = 0, 0, 0
local hiddenYaw, hiddenPitch, hiddenRoll = 0, 0, 0
local previousAccelerationX, previousAccelerationZ = 0, 0
local accelerationInitialized = false
local INVALID_SPLINE_POINT = vec3(-1, -1, -1)

local function expSmooth(current, target, speed, dt)
  local alpha = 1 - math.exp(-math.max(speed, 0.01) * dt)
  return current + (target - current) * alpha
end

local function responseLag(lag, overallSpeed)
  return math.pow(math.clamp(lag, 0.001, 0.9999), math.max(overallSpeed, 0.05))
end

local function publishZeroOutput()
  live.neckEffectStrength = 0
  live.neckOutputX, live.neckOutputY, live.neckOutputZ = 0, 0, 0
  live.neckOutputYaw, live.neckOutputPitch, live.neckOutputRoll = 0, 0, 0
end

local function resetRuntime()
  turnHead, driftState, angleMult = 0, 1, 0
  steerSmooth, targetAngle, lastAngle, steerSpeed = 0, 0, 0, 1
  lookAheadX, lookAheadY, lookAheadBlend = 0, 0, 0
  moveX, moveY, moveZ = 0, 0, 0
  dynamicYaw, dynamicPitch, dynamicRoll = 0, 0, 0
  driftYaw, roadPitch, bankRoll = 0, 0, 0
  speedPitch, speedYaw, speedRoll = 0, 0, 0
  hiddenYaw, hiddenPitch, hiddenRoll = 0, 0, 0
  previousAccelerationX, previousAccelerationZ = 0, 0
  accelerationInitialized = false
  publishZeroOutput()
end

function script.update(dt, mode, turnMix)
  live.backendPresent = true
  live.backendSequence = live.appSequence
  dt = math.clamp(dt or 0, 0, 0.05)
  if dt <= 0 then return end
  if not live.suiteEnabled or not live.neckEnabled or not live.neckDynamicMovement then
    resetRuntime()
    return
  end

  local overallSpeed = math.max(live.neckOverallSpeed, 0.05)
  local slideFollowing = live.neckSlideFollowing and 1 or 0
  local trackFollowingSetting = live.neckTrackFollowing and 1 or 0

  local sliding = car.localVelocity.x / math.max(3, car.speedMs)
  local slidingMult = math.abs(sliding) * live.neckSlidingLookMult
  driftState = slidingMult > 0.2
    and driftState - dt * overallSpeed / 2 or driftState + dt * overallSpeed / 4
  driftState = math.saturate(driftState + (1 - slideFollowing))
  angleMult = math.applyLag(angleMult, slidingMult * 0.5,
    responseLag(0.99, overallSpeed), dt)
  local thMult = math.max(slidingMult - 0.2 * driftState, 0) * math.sign(sliding)
  turnHead = math.applyLag(turnHead, thMult,
    responseLag(0.964 + angleMult / 50, overallSpeed), dt)
  local powDriftState = math.pow(driftState, 2)

  local tyre = car.wheels[car.steer > 0 and 0 or 1]
  local steering = -(math.acos(math.dot(tyre.transform.look, car.side)) - math.pi / 2)
    * 2 * math.saturate(car.speedMs / 10 - 0.1)
  steering = math.max(math.abs(steering) - 0.05, 0) * math.sign(steering)
  local slipAngle = math.sin(math.abs(math.angle(tyre.transform.side, tyre.velocity)
    - math.pi / 2))
  targetAngle = math.applyLag(targetAngle, steering / (1 + slipAngle),
    responseLag(0.97, overallSpeed), dt)
  steerSpeed = math.min(math.pow(math.abs(lastAngle - steering), 1.5) * 0.15, 0.15)
  lastAngle = targetAngle
  steerSmooth = math.applyLag(steerSmooth, targetAngle * powDriftState,
    responseLag(0.85 - steerSpeed, overallSpeed), dt)

  local splinePoint = ac.trackProgressToWorldCoordinate(car.splinePosition)
  local splineDistance = splinePoint:distance(car.position)
  local targetPoint = ac.trackProgressToWorldCoordinate((car.splinePosition
    + live.neckLookaheadDistance / sim.trackLengthM) % 1)
  local lookAheadDelta = targetPoint:sub(splinePoint):normalize()
  local facingForward = math.pow(math.saturate(math.dot(lookAheadDelta, car.look)), 0.5)
  local blendNow = math.lerpInvSat(splineDistance, 15, 8) * facingForward
  lookAheadBlend = math.applyLag(lookAheadBlend, blendNow,
    responseLag(0.99, overallSpeed), dt)
  lookAheadX = math.applyLag(lookAheadX,
    math.dot(lookAheadDelta * powDriftState * math.saturate(car.speedMs / 10 - 0.1)
      * live.neckTrackFollowingMult, car.side) * lookAheadBlend,
    responseLag(0.95, overallSpeed), dt)
  local lookAheadYMult = math.dot(lookAheadDelta * 0.7, car.groundNormal) * lookAheadBlend
  if lookAheadYMult < 0 then lookAheadYMult = lookAheadYMult / 2 end
  lookAheadY = math.applyLag(lookAheadY, lookAheadYMult,
    responseLag(0.98, overallSpeed), dt)
  local validTrackFollowing = targetPoint == INVALID_SPLINE_POINT and 0
    or trackFollowingSetting
  local mainTurn = turnHead * slideFollowing
    + math.lerp(steerSmooth * live.neckSteeringMult, lookAheadX, validTrackFollowing)

  local gScale = 1 / math.max(live.neckGForceAtFull, 0.1)
  local lateralInput = math.clamp(-car.acceleration.x * gScale, -1, 1)
  local verticalInput = math.clamp(car.acceleration.y * gScale, -1, 1)
  local longitudinalInput = math.clamp(-car.acceleration.z * gScale, -1, 1)
  local yawInput = math.clamp(mainTurn * turnMix, -1, 1)
  local trackPitchInput = math.clamp(lookAheadY * turnMix
    * validTrackFollowing * 2, -1, 1)
  local pitchInput = math.clamp(-longitudinalInput, -1, 1)
  local driftYawInput = slideFollowing ~= 0 and math.clamp(sliding * 3, -1, 1) or 0
  local bankRollInput = math.clamp(math.dot(car.groundNormal, car.side) * 3, -1, 1)
  local speedAngleRange = math.max(live.neckSpeedAngleFullKmh
    - live.neckSpeedAngleStartKmh, 1)
  local speedAngleBlend = math.saturate((car.speedKmh
    - live.neckSpeedAngleStartKmh) / speedAngleRange)
  local speedDirectionInput = yawInput * speedAngleBlend

  local hiddenYawInput = math.clamp(-car.localAngularVelocity.y /
    math.max(live.neckHiddenYawRateAtFull, 0.1), -1, 1)
  local hiddenPitchInput, hiddenRollInput = 0, 0
  if accelerationInitialized then
    local jerkScale = 1 / math.max(live.neckHiddenJerkAtFull, 0.5)
    hiddenPitchInput = math.clamp(-(car.acceleration.z - previousAccelerationZ)
      / math.max(dt, 0.005) * jerkScale, -1, 1)
    hiddenRollInput = math.clamp(-(car.acceleration.x - previousAccelerationX)
      / math.max(dt, 0.005) * jerkScale, -1, 1)
  else
    accelerationInitialized = true
  end
  previousAccelerationX = car.acceleration.x
  previousAccelerationZ = car.acceleration.z

  moveX = expSmooth(moveX, lateralInput * live.neckMoveXDistance,
    live.neckMoveXSpeed * overallSpeed, dt)
  moveY = expSmooth(moveY, verticalInput * live.neckMoveYDistance,
    live.neckMoveYSpeed * overallSpeed, dt)
  moveZ = expSmooth(moveZ, longitudinalInput * live.neckMoveZDistance,
    live.neckMoveZSpeed * overallSpeed, dt)
  dynamicYaw = expSmooth(dynamicYaw, yawInput * math.rad(live.neckYawAngle),
    live.neckYawSpeed * overallSpeed, dt)
  dynamicPitch = expSmooth(dynamicPitch, pitchInput * math.rad(live.neckPitchAngle),
    live.neckPitchSpeed * overallSpeed, dt)
  dynamicRoll = expSmooth(dynamicRoll, lateralInput * math.rad(live.neckRollAngle),
    live.neckRollSpeed * overallSpeed, dt)
  driftYaw = expSmooth(driftYaw, driftYawInput * math.rad(live.neckDriftYawAngle),
    live.neckDriftYawSpeed * overallSpeed, dt)
  roadPitch = expSmooth(roadPitch, trackPitchInput * math.rad(live.neckRoadPitchAngle),
    live.neckRoadPitchSpeed * overallSpeed, dt)
  bankRoll = expSmooth(bankRoll, bankRollInput * math.rad(live.neckBankRollAngle),
    live.neckBankRollSpeed * overallSpeed, dt)
  speedPitch = expSmooth(speedPitch, -speedAngleBlend * math.rad(live.neckSpeedPitchAngle),
    live.neckSpeedPitchSpeed * overallSpeed, dt)
  speedYaw = expSmooth(speedYaw, speedDirectionInput * math.rad(live.neckSpeedYawAngle),
    live.neckSpeedYawSpeed * overallSpeed, dt)
  speedRoll = expSmooth(speedRoll, -speedDirectionInput * math.rad(live.neckSpeedRollAngle),
    live.neckSpeedRollSpeed * overallSpeed, dt)
  hiddenYaw = expSmooth(hiddenYaw, hiddenYawInput * math.rad(live.neckHiddenYawAngle),
    live.neckHiddenYawSpeed * overallSpeed, dt)
  hiddenPitch = expSmooth(hiddenPitch, hiddenPitchInput * math.rad(live.neckHiddenPitchAngle),
    live.neckHiddenPitchSpeed * overallSpeed, dt)
  hiddenRoll = expSmooth(hiddenRoll, hiddenRollInput * math.rad(live.neckHiddenRollAngle),
    live.neckHiddenRollSpeed * overallSpeed, dt)

  if car.justJumped then resetRuntime() end

  local baseYaw = dynamicYaw + driftYaw + speedYaw + hiddenYaw
  local basePitch = dynamicPitch + roadPitch + speedPitch + hiddenPitch
  local baseRoll = dynamicRoll + bankRoll + speedRoll + hiddenRoll
  local mixedYaw = baseYaw + baseRoll * live.neckMixRollToYaw
  local mixedPitch = basePitch + baseRoll * live.neckMixRollToPitch
  local mixedRoll = baseRoll + baseYaw * live.neckMixYawToRoll
    + basePitch * live.neckMixPitchToRoll
  local mixedX = moveX + moveZ * live.neckMixZToX
  local mixedY = moveY + moveZ * live.neckMixZToY
  local mixedZ = moveZ + moveX * live.neckMixXToZ + moveY * live.neckMixYToZ

  local capKmh = math.max(live.neckEffectSpeedCap, 1)
  if live.neckEffectSpeedCapMph then capKmh = capKmh * 1.609344 end
  local effectScale = math.clamp(math.abs(car.speedKmh) / capKmh, 0, 1)
  mixedX, mixedY, mixedZ = mixedX * effectScale, mixedY * effectScale, mixedZ * effectScale
  mixedYaw, mixedPitch, mixedRoll = mixedYaw * effectScale,
    mixedPitch * effectScale, mixedRoll * effectScale

  live.neckEffectStrength = effectScale
  live.neckOutputX, live.neckOutputY, live.neckOutputZ = mixedX, mixedY, mixedZ
  live.neckOutputYaw = math.deg(mixedYaw)
  live.neckOutputPitch = math.deg(mixedPitch)
  live.neckOutputRoll = math.deg(mixedRoll)

  neck.position:addScaled(car.side, mixedX)
  neck.position:addScaled(car.up, mixedY)
  neck.position:addScaled(car.look, mixedZ)
  neck.look:addScaled(car.side, mixedYaw)
  neck.look:addScaled(car.up, mixedPitch)
  neck.up:addScaled(car.side, mixedRoll)
end
