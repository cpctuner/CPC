-- CPC Drive Suite 3.0.1
-- One CSP shelf app for adaptive clutch control, throttle camera effects,
-- live NeckFX tuning and a custom-drawn telemetry HUD.

local PLAYER = 0
local sim = ac.getSim()

local DEFAULTS = {
  suiteEnabled = true,

  -- Adaptive clutch.
  clutchEnabled = true,
  clutchLaunchEnabled = true,
  clutchAntiStallEnabled = true,
  clutchShiftEnabled = true,
  clutchTurnAware = true,
  clutchKickEnabled = false,
  clutchLaunchRPMPercent = 24,
  clutchLaunchEndSpeed = 16,
  clutchLaunchThrottle = 0.12,
  clutchAntiStallMargin = 420,
  clutchAntiStallSpeed = 38,
  clutchRPMLookahead = 0.14,
  clutchBrakeThreshold = 0.12,
  clutchTurnLoadStart = 0.22,
  clutchTurnExtraMargin = 260,
  clutchPressRate = 22,
  clutchReleaseRate = 5.0,
  clutchShiftHold = 0.075,
  clutchShiftRelease = 0.16,
  clutchKickRPMPercent = 50,
  clutchKickThrottle = 0.64,
  clutchKickSteer = 0.38,
  clutchKickMinSpeed = 20,
  clutchKickDuration = 0.085,
  clutchKickCooldown = 0.65,
  clutchKickRPMDrop = 650,

  -- Direct onboard camera and FOV layer.
  throttleEnabled = true,
  throttleOverallSpeed = 1.0,
  throttleRestingFov = 60,
  throttleMaximumFov = 90,
  throttleFovWidenSpeed = 8,
  throttleFovReturnSpeed = 6,
  throttleDeadzone = 0.01,
  throttleCurve = 1.0,
  throttleEffectSpeedCap = 20,
  throttleEffectSpeedCapMph = false,
  throttleStartX = 0,
  throttleStartY = 0,
  throttleStartZ = 0,
  throttleStartPitch = 0,
  throttleForwardDistance = 0.100,
  throttleForwardSpeed = 8,
  throttleVerticalDistance = 0.015,
  throttleVerticalSpeed = 8,
  throttleLateralDistance = 0.025,
  throttleLateralSpeed = 8,
  throttleSteeringAtFull = 360,
  throttlePitchAngle = 4,
  throttlePitchSpeed = 8,
  throttleYawAngle = 6,
  throttleYawSpeed = 8,
  throttleFovForwardMix = 3.0,
  throttleFovVerticalMix = 0.5,
  throttleFovLateralMix = 0.75,
  throttleFovPitchMix = 0.75,
  throttleFovYawMix = 0.75,
  throttleFovSpeedMix = 2.0,
  throttleFovMixStrength = 1.0,
  throttleFovMixSpeed = 8,
  throttleFovMixLimit = 12,

  -- NeckFX backend.
  neckEnabled = true,
  neckDynamicMovement = true,
  neckOverallSpeed = 1.0,
  neckGForceAtFull = 1.5,
  neckEffectSpeedCap = 20,
  neckEffectSpeedCapMph = false,
  neckMoveXDistance = 0.035,
  neckMoveXSpeed = 9,
  neckMoveYDistance = 0.015,
  neckMoveYSpeed = 12,
  neckMoveZDistance = 0.040,
  neckMoveZSpeed = 9,
  neckYawAngle = 10,
  neckYawSpeed = 8,
  neckPitchAngle = 8,
  neckPitchSpeed = 9,
  neckRollAngle = 10,
  neckRollSpeed = 9,
  neckDriftYawAngle = 12,
  neckDriftYawSpeed = 9,
  neckRoadPitchAngle = 8,
  neckRoadPitchSpeed = 7,
  neckBankRollAngle = 10,
  neckBankRollSpeed = 8,
  neckSpeedAngleStartKmh = 20,
  neckSpeedAngleFullKmh = 180,
  neckSpeedPitchAngle = 5,
  neckSpeedPitchSpeed = 6,
  neckSpeedYawAngle = 8,
  neckSpeedYawSpeed = 8,
  neckSpeedRollAngle = 8,
  neckSpeedRollSpeed = 8,
  neckHiddenJerkAtFull = 8,
  neckHiddenYawRateAtFull = 1.0,
  neckHiddenYawAngle = 3,
  neckHiddenYawSpeed = 12,
  neckHiddenPitchAngle = 2.5,
  neckHiddenPitchSpeed = 14,
  neckHiddenRollAngle = 3,
  neckHiddenRollSpeed = 14,
  neckMixYawToRoll = 0.20,
  neckMixRollToYaw = 0.10,
  neckMixPitchToRoll = 0.05,
  neckMixRollToPitch = 0.10,
  neckMixXToZ = 0.15,
  neckMixZToX = 0.10,
  neckMixYToZ = 0.15,
  neckMixZToY = 0.20,
  neckSlideFollowing = true,
  neckSlidingLookMult = 0.5,
  neckTrackFollowing = true,
  neckTrackFollowingMult = 0.7,
  neckSteeringMult = 0.7,
  neckLookaheadDistance = 20,

  -- Values written by the NeckFX backend for status and HUD output.
  neckHeartbeat = 0,
  neckEffectStrength = 0,
  neckOutputX = 0,
  neckOutputY = 0,
  neckOutputZ = 0,
  neckOutputYaw = 0,
  neckOutputPitch = 0,
  neckOutputRoll = 0,

  -- UI and HUD preferences.
  uiPage = 1,
  clutchPage = 1,
  throttlePage = 1,
  neckPage = 1,
  colorTheme = 1,
  uiScale = 1.0,
  hudMode = 1,
  hudOpacity = 0.94,
  hudAnimation = 1.0,
  hudSpeedMph = false,
  hudShowWheel = true,
  hudShowPedals = true,
  hudShowCamera = true,
  hudShowRPM = true,
  hudShowStatus = true,
  settingsVersion = 0
}

-- Import the former Dynamic 6DOF tuning once. Missing legacy storage simply
-- yields the same defaults, so first-time users follow the same path safely.
ac.storageSetPath('cpc-dynamic-6dof-live')
local legacyNeck = ac.storage({
  dynamicMovement = true,
  overallSpeed = 1.0,
  gForceAtFull = 1.5,
  effectSpeedCap = 20,
  effectSpeedCapMph = false,
  moveXDistance = 0.035,
  moveXSpeed = 9,
  moveYDistance = 0.015,
  moveYSpeed = 12,
  moveZDistance = 0.040,
  moveZSpeed = 9,
  yawAngle = 10,
  yawSpeed = 8,
  pitchAngle = 8,
  pitchSpeed = 9,
  rollAngle = 10,
  rollSpeed = 9,
  driftYawAngle = 12,
  driftYawSpeed = 9,
  roadPitchAngle = 8,
  roadPitchSpeed = 7,
  bankRollAngle = 10,
  bankRollSpeed = 8,
  speedAngleStartKmh = 20,
  speedAngleFullKmh = 180,
  speedPitchAngle = 5,
  speedPitchSpeed = 6,
  speedYawAngle = 8,
  speedYawSpeed = 8,
  speedRollAngle = 8,
  speedRollSpeed = 8,
  hiddenJerkAtFull = 8,
  hiddenYawRateAtFull = 1.0,
  hiddenYawAngle = 3,
  hiddenYawSpeed = 12,
  hiddenPitchAngle = 2.5,
  hiddenPitchSpeed = 14,
  hiddenRollAngle = 3,
  hiddenRollSpeed = 14,
  mixYawToRoll = 0.20,
  mixRollToYaw = 0.10,
  mixPitchToRoll = 0.05,
  mixRollToPitch = 0.10,
  mixXToZ = 0.15,
  mixZToX = 0.10,
  mixYToZ = 0.15,
  mixZToY = 0.20,
  slideFollowing = true,
  slidingLookMult = 0.5,
  trackFollowing = true,
  trackFollowingMult = 0.7,
  steeringMult = 0.7,
  lookaheadDistance = 20
})

ac.storageSetPath('cpc-drive-suite-v1')
local settings = ac.storage(DEFAULTS)
if settings.settingsVersion < 1 then
  local legacyMap = {
    neckDynamicMovement = 'dynamicMovement',
    neckOverallSpeed = 'overallSpeed',
    neckGForceAtFull = 'gForceAtFull',
    neckEffectSpeedCap = 'effectSpeedCap',
    neckEffectSpeedCapMph = 'effectSpeedCapMph',
    neckMoveXDistance = 'moveXDistance', neckMoveXSpeed = 'moveXSpeed',
    neckMoveYDistance = 'moveYDistance', neckMoveYSpeed = 'moveYSpeed',
    neckMoveZDistance = 'moveZDistance', neckMoveZSpeed = 'moveZSpeed',
    neckYawAngle = 'yawAngle', neckYawSpeed = 'yawSpeed',
    neckPitchAngle = 'pitchAngle', neckPitchSpeed = 'pitchSpeed',
    neckRollAngle = 'rollAngle', neckRollSpeed = 'rollSpeed',
    neckDriftYawAngle = 'driftYawAngle', neckDriftYawSpeed = 'driftYawSpeed',
    neckRoadPitchAngle = 'roadPitchAngle', neckRoadPitchSpeed = 'roadPitchSpeed',
    neckBankRollAngle = 'bankRollAngle', neckBankRollSpeed = 'bankRollSpeed',
    neckSpeedAngleStartKmh = 'speedAngleStartKmh',
    neckSpeedAngleFullKmh = 'speedAngleFullKmh',
    neckSpeedPitchAngle = 'speedPitchAngle', neckSpeedPitchSpeed = 'speedPitchSpeed',
    neckSpeedYawAngle = 'speedYawAngle', neckSpeedYawSpeed = 'speedYawSpeed',
    neckSpeedRollAngle = 'speedRollAngle', neckSpeedRollSpeed = 'speedRollSpeed',
    neckHiddenJerkAtFull = 'hiddenJerkAtFull',
    neckHiddenYawRateAtFull = 'hiddenYawRateAtFull',
    neckHiddenYawAngle = 'hiddenYawAngle', neckHiddenYawSpeed = 'hiddenYawSpeed',
    neckHiddenPitchAngle = 'hiddenPitchAngle', neckHiddenPitchSpeed = 'hiddenPitchSpeed',
    neckHiddenRollAngle = 'hiddenRollAngle', neckHiddenRollSpeed = 'hiddenRollSpeed',
    neckMixYawToRoll = 'mixYawToRoll', neckMixRollToYaw = 'mixRollToYaw',
    neckMixPitchToRoll = 'mixPitchToRoll', neckMixRollToPitch = 'mixRollToPitch',
    neckMixXToZ = 'mixXToZ', neckMixZToX = 'mixZToX',
    neckMixYToZ = 'mixYToZ', neckMixZToY = 'mixZToY',
    neckSlideFollowing = 'slideFollowing',
    neckSlidingLookMult = 'slidingLookMult',
    neckTrackFollowing = 'trackFollowing',
    neckTrackFollowingMult = 'trackFollowingMult',
    neckSteeringMult = 'steeringMult',
    neckLookaheadDistance = 'lookaheadDistance'
  }
  for newKey, oldKey in pairs(legacyMap) do settings[newKey] = legacyNeck[oldKey] end
  settings.settingsVersion = 1
end

-- Storage is persistent but separate Lua runtimes do not get a live view of
-- each other's storage proxies. Use a typed CSP connection for live NeckFX
-- settings, heartbeat acknowledgement and rendered output telemetry.
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

local neckSequence = 0
local neckLastAck = 0
local neckLastAckTime = -1e9
local neckTelemetry = {
  effectStrength = 0,
  outputX = 0,
  outputY = 0,
  outputZ = 0,
  outputYaw = 0,
  outputPitch = 0,
  outputRoll = 0
}

local function syncNeckLink()
  neckSequence = (neckSequence + 1) % 4294967295
  neckLink.appSequence = neckSequence
  neckLink.suiteEnabled = settings.suiteEnabled
  neckLink.neckEnabled = settings.neckEnabled
  neckLink.neckDynamicMovement = settings.neckDynamicMovement
  neckLink.neckOverallSpeed = settings.neckOverallSpeed
  neckLink.neckGForceAtFull = settings.neckGForceAtFull
  neckLink.neckEffectSpeedCap = settings.neckEffectSpeedCap
  neckLink.neckEffectSpeedCapMph = settings.neckEffectSpeedCapMph
  neckLink.neckMoveXDistance = settings.neckMoveXDistance
  neckLink.neckMoveXSpeed = settings.neckMoveXSpeed
  neckLink.neckMoveYDistance = settings.neckMoveYDistance
  neckLink.neckMoveYSpeed = settings.neckMoveYSpeed
  neckLink.neckMoveZDistance = settings.neckMoveZDistance
  neckLink.neckMoveZSpeed = settings.neckMoveZSpeed
  neckLink.neckYawAngle = settings.neckYawAngle
  neckLink.neckYawSpeed = settings.neckYawSpeed
  neckLink.neckPitchAngle = settings.neckPitchAngle
  neckLink.neckPitchSpeed = settings.neckPitchSpeed
  neckLink.neckRollAngle = settings.neckRollAngle
  neckLink.neckRollSpeed = settings.neckRollSpeed
  neckLink.neckDriftYawAngle = settings.neckDriftYawAngle
  neckLink.neckDriftYawSpeed = settings.neckDriftYawSpeed
  neckLink.neckRoadPitchAngle = settings.neckRoadPitchAngle
  neckLink.neckRoadPitchSpeed = settings.neckRoadPitchSpeed
  neckLink.neckBankRollAngle = settings.neckBankRollAngle
  neckLink.neckBankRollSpeed = settings.neckBankRollSpeed
  neckLink.neckSpeedAngleStartKmh = settings.neckSpeedAngleStartKmh
  neckLink.neckSpeedAngleFullKmh = settings.neckSpeedAngleFullKmh
  neckLink.neckSpeedPitchAngle = settings.neckSpeedPitchAngle
  neckLink.neckSpeedPitchSpeed = settings.neckSpeedPitchSpeed
  neckLink.neckSpeedYawAngle = settings.neckSpeedYawAngle
  neckLink.neckSpeedYawSpeed = settings.neckSpeedYawSpeed
  neckLink.neckSpeedRollAngle = settings.neckSpeedRollAngle
  neckLink.neckSpeedRollSpeed = settings.neckSpeedRollSpeed
  neckLink.neckHiddenJerkAtFull = settings.neckHiddenJerkAtFull
  neckLink.neckHiddenYawRateAtFull = settings.neckHiddenYawRateAtFull
  neckLink.neckHiddenYawAngle = settings.neckHiddenYawAngle
  neckLink.neckHiddenYawSpeed = settings.neckHiddenYawSpeed
  neckLink.neckHiddenPitchAngle = settings.neckHiddenPitchAngle
  neckLink.neckHiddenPitchSpeed = settings.neckHiddenPitchSpeed
  neckLink.neckHiddenRollAngle = settings.neckHiddenRollAngle
  neckLink.neckHiddenRollSpeed = settings.neckHiddenRollSpeed
  neckLink.neckMixYawToRoll = settings.neckMixYawToRoll
  neckLink.neckMixRollToYaw = settings.neckMixRollToYaw
  neckLink.neckMixPitchToRoll = settings.neckMixPitchToRoll
  neckLink.neckMixRollToPitch = settings.neckMixRollToPitch
  neckLink.neckMixXToZ = settings.neckMixXToZ
  neckLink.neckMixZToX = settings.neckMixZToX
  neckLink.neckMixYToZ = settings.neckMixYToZ
  neckLink.neckMixZToY = settings.neckMixZToY
  neckLink.neckSlideFollowing = settings.neckSlideFollowing
  neckLink.neckSlidingLookMult = settings.neckSlidingLookMult
  neckLink.neckTrackFollowing = settings.neckTrackFollowing
  neckLink.neckTrackFollowingMult = settings.neckTrackFollowingMult
  neckLink.neckSteeringMult = settings.neckSteeringMult
  neckLink.neckLookaheadDistance = settings.neckLookaheadDistance

  local ack = neckLink.backendSequence
  local previousSequence = neckSequence == 0 and 4294967294 or neckSequence - 1
  if ack ~= neckLastAck and (ack == neckSequence or ack == previousSequence) then
    neckLastAck = ack
    neckLastAckTime = os.preciseClock()
  end
  neckTelemetry.effectStrength = neckLink.neckEffectStrength
  neckTelemetry.outputX = neckLink.neckOutputX
  neckTelemetry.outputY = neckLink.neckOutputY
  neckTelemetry.outputZ = neckLink.neckOutputZ
  neckTelemetry.outputYaw = neckLink.neckOutputYaw
  neckTelemetry.outputPitch = neckLink.neckOutputPitch
  neckTelemetry.outputRoll = neckLink.neckOutputRoll
end

local controlsOverride = ac.overrideCarControls and ac.overrideCarControls(PLAYER) or nil

local function clamp(value, minimum, maximum)
  return math.max(minimum, math.min(value, maximum))
end

local function saturate(value)
  return clamp(value, 0, 1)
end

local function moveTowards(current, target, maximumDelta)
  if current < target then return math.min(current + maximumDelta, target) end
  return math.max(current - maximumDelta, target)
end

local function expSmooth(current, target, speed, dt)
  local alpha = 1 - math.exp(-math.max(speed, 0.01) * dt)
  return current + (target - current) * alpha
end

local function signWithDeadzone(value, deadzone)
  if value > deadzone then return 1 end
  if value < -deadzone then return -1 end
  return 0
end

local function copyDefaultsWithPrefix(prefix)
  for key, value in pairs(DEFAULTS) do
    if string.sub(key, 1, #prefix) == prefix then settings[key] = value end
  end
end

local telemetry = {
  rpm = 0,
  idleRPM = 850,
  limiterRPM = 7000,
  launchRPM = 2300,
  kickRPM = 3900,
  gas = 0,
  brake = 0,
  rawClutch = 1,
  steer = 0,
  speed = 0,
  gear = 0,
  builtInAutoClutch = false,
  clutchOverrideActive = false,
  accelerationX = 0,
  accelerationY = 0,
  accelerationZ = 0
}

-- Adaptive clutch runtime ----------------------------------------------------

local clutchCommand = 1
local clutchTarget = 1
local rpmTrend = 0
local previousRPM = nil
local previousGear = nil
local previousEngagedGear = nil
local previousGearUp = false
local previousGearDown = false
local previousRequestedGear = 0
local previousStrongTurn = 0
local previousResetCounter = nil
local clutchHistoryReady = false
local shiftElapsed = 0
local shiftActive = false
local kickRemaining = 0
local kickCooldownRemaining = 0
local clutchStatus = 'Waiting for physics'
local clutchStatusKind = 'idle'
local actionFlash = 0
local elapsedTime = 0

local function setClutchOverride(value)
  clutchCommand = saturate(value)
  if controlsOverride then controlsOverride.clutch = clutchCommand end
end

local function releaseClutch(reason, kind)
  clutchTarget = 1
  setClutchOverride(1)
  shiftActive = false
  kickRemaining = 0
  clutchStatus = reason or 'Clutch assist disabled'
  clutchStatusKind = kind or 'idle'
end

local function resetClutchRuntime(car)
  clutchCommand, clutchTarget, rpmTrend = 1, 1, 0
  previousRPM = car and car.rpm or nil
  previousGear = car and car.gear or nil
  previousEngagedGear = car and car.engagedGear or nil
  previousGearUp, previousGearDown = false, false
  previousRequestedGear, previousStrongTurn = 0, 0
  shiftElapsed, kickRemaining, kickCooldownRemaining = 0, 0, 0
  shiftActive, clutchHistoryReady = false, false
  setClutchOverride(1)
end

local function rpmBounds(car)
  local idle = car.rpmMinimum
  if not idle or idle < 400 then idle = 850 end
  local limiter = car.rpmLimiter
  if not limiter or limiter < idle + 1200 then
    limiter = math.max(7000, (car.rpm or 0) + 1500)
  end
  return idle, limiter
end

local function getRawInputs(car)
  local raw = physics and physics.getCarInputControls and physics.getCarInputControls() or nil
  if not raw then
    return nil, car.gas or 0, car.brake or 0, car.clutch or 1, 0
  end
  return raw, raw.gas or 0, raw.brake or 0, raw.clutch or 1, raw.steer or 0
end

local function updateClutchHistory(car, raw, strongTurn)
  previousRPM = car.rpm
  previousGear = car.gear
  previousEngagedGear = car.engagedGear
  previousGearUp = raw and raw.gearUp or false
  previousGearDown = raw and raw.gearDown or false
  previousRequestedGear = raw and raw.requestedGearIndex or 0
  if strongTurn ~= 0 then previousStrongTurn = strongTurn end
  clutchHistoryReady = true
end

local function updateAdaptiveClutch(dt, car)
  if not car then
    releaseClutch('No player car')
    return
  end

  local raw, gas, brake, rawClutch, steer = getRawInputs(car)
  local speed = math.abs(car.speedKmh or 0)
  local idleRPM, limiterRPM = rpmBounds(car)
  local launchRPM = idleRPM + (limiterRPM - idleRPM) * settings.clutchLaunchRPMPercent / 100
  local kickRPM = idleRPM + (limiterRPM - idleRPM) * settings.clutchKickRPMPercent / 100

  if previousRPM then
    local rawTrend = clamp((car.rpm - previousRPM) / math.max(dt, 1 / 240), -20000, 20000)
    rpmTrend = expSmooth(rpmTrend, rawTrend, 9, dt)
  end

  local turnDeadzone = math.max(settings.clutchTurnLoadStart, 0.02)
  local strongTurn = signWithDeadzone(steer,
    math.max(settings.clutchKickSteer, turnDeadzone))
  local directionChanged = clutchHistoryReady and strongTurn ~= 0
    and previousStrongTurn ~= 0 and strongTurn ~= previousStrongTurn

  telemetry.rpm = car.rpm or 0
  telemetry.idleRPM = idleRPM
  telemetry.limiterRPM = limiterRPM
  telemetry.launchRPM = launchRPM
  telemetry.kickRPM = kickRPM
  telemetry.gas = gas
  telemetry.brake = brake
  telemetry.rawClutch = rawClutch
  telemetry.steer = steer
  telemetry.speed = speed
  telemetry.gear = car.gear or 0
  telemetry.builtInAutoClutch = car.autoClutch or false
  telemetry.clutchOverrideActive = controlsOverride and controlsOverride:active() or false
  telemetry.accelerationX = car.acceleration and car.acceleration.x or 0
  telemetry.accelerationY = car.acceleration and car.acceleration.y or 0
  telemetry.accelerationZ = car.acceleration and car.acceleration.z or 0

  if previousResetCounter ~= nil and car.resetCounter ~= previousResetCounter then
    resetClutchRuntime(car)
  end
  previousResetCounter = car.resetCounter

  if not settings.suiteEnabled or not settings.clutchEnabled then
    releaseClutch(settings.suiteEnabled and 'Clutch assist disabled' or 'Suite paused')
    updateClutchHistory(car, raw, strongTurn)
    return
  end
  if not controlsOverride then
    releaseClutch('CSP control override unavailable', 'warning')
    updateClutchHistory(car, raw, strongTurn)
    return
  end
  if not car.physicsAvailable or car.isAIControlled or not car.isUserControlled then
    releaseClutch('Waiting for player physics')
    updateClutchHistory(car, raw, strongTurn)
    return
  end

  kickCooldownRemaining = math.max(0, kickCooldownRemaining - dt)
  local gearUp = raw and raw.gearUp or false
  local gearDown = raw and raw.gearDown or false
  local requestedGear = raw and raw.requestedGearIndex or 0
  local gearButtonEdge = (gearUp and not previousGearUp) or (gearDown and not previousGearDown)
  local directGearEdge = requestedGear ~= 0 and requestedGear ~= previousRequestedGear
  local gearChanged = clutchHistoryReady
    and (car.gear ~= previousGear or car.engagedGear ~= previousEngagedGear)
  if settings.clutchShiftEnabled and clutchHistoryReady
      and (gearButtonEdge or directGearEdge or gearChanged) then
    shiftElapsed, shiftActive = 0, true
  end

  local target, reason, kind = 1, 'Clutch coupled', 'active'
  local inGear = car.gear ~= 0 or car.engagedGear ~= 0

  if settings.clutchLaunchEnabled and inGear and speed < settings.clutchLaunchEndSpeed then
    local speedFactor = saturate(speed / math.max(settings.clutchLaunchEndSpeed, 1))
    local launchStartRPM = idleRPM + math.min(260, settings.clutchAntiStallMargin * 0.55)
    local rpmFactor = saturate((car.rpm - launchStartRPM) /
      math.max(launchRPM - launchStartRPM, 200))
    if gas < settings.clutchLaunchThrottle then
      target = speed < 1.5 and 0 or speedFactor
      reason = brake >= settings.clutchBrakeThreshold
        and 'Holding clutch at stop' or 'Waiting for launch throttle'
    else
      target = math.max(speedFactor, rpmFactor)
      if target < 0.98 then reason = 'Adaptive launch slip' end
    end
    if brake >= settings.clutchBrakeThreshold and speed < 2.5 then
      target, reason = 0, 'Brake hold - clutch disengaged'
    end
    if target < 0.98 then kind = 'action' end
  end

  if settings.clutchAntiStallEnabled and inGear and speed < settings.clutchAntiStallSpeed then
    local steerLoad = saturate((math.abs(steer) - settings.clutchTurnLoadStart) /
      math.max(1 - settings.clutchTurnLoadStart, 0.05))
    local turnRPM = settings.clutchTurnAware and steerLoad * settings.clutchTurnExtraMargin or 0
    local brakeRPM = brake >= settings.clutchBrakeThreshold and 100 * brake or 0
    local threshold = idleRPM + settings.clutchAntiStallMargin + turnRPM + brakeRPM
    local predictedRPM = car.rpm + math.min(rpmTrend, 0) * settings.clutchRPMLookahead
    local loadingEngine = brake >= settings.clutchBrakeThreshold or gas < 0.38
      or rpmTrend < -250 or car.rpm < idleRPM + 130
    if predictedRPM < threshold and loadingEngine then
      local danger = saturate((threshold - predictedRPM) /
        math.max(settings.clutchAntiStallMargin, 120))
      local antiStallTarget = 1 - danger
      if car.rpm < idleRPM + 90 then antiStallTarget = 0 end
      if antiStallTarget < target then
        target = antiStallTarget
        reason = math.abs(steer) >= settings.clutchTurnLoadStart
          and 'Turn-aware anti-stall' or 'Predictive anti-stall'
        kind = 'action'
      end
    end
  end

  local kickCondition = settings.clutchKickEnabled and inGear
    and speed >= settings.clutchKickMinSpeed
    and gas >= settings.clutchKickThrottle and brake < 0.25
    and math.abs(steer) >= settings.clutchKickSteer and car.rpm < kickRPM
    and (rpmTrend <= -settings.clutchKickRPMDrop or directionChanged)
  if kickCondition and kickCooldownRemaining <= 0 and kickRemaining <= 0 then
    kickRemaining = settings.clutchKickDuration
    kickCooldownRemaining = settings.clutchKickCooldown
  end
  if kickRemaining > 0 then
    target = 0
    reason = directionChanged and 'Direction-change clutch kick' or 'Low-RPM clutch kick'
    kind = 'action'
    kickRemaining = math.max(0, kickRemaining - dt)
  end

  if shiftActive then
    local total = settings.clutchShiftHold + settings.clutchShiftRelease
    local shiftTarget = shiftElapsed < settings.clutchShiftHold and 0
      or saturate((shiftElapsed - settings.clutchShiftHold) /
        math.max(settings.clutchShiftRelease, 0.02))
    target = math.min(target, shiftTarget)
    reason = shiftElapsed < settings.clutchShiftHold
      and 'Shift - clutch pressed' or 'Shift - clutch releasing'
    kind = 'action'
    shiftElapsed = shiftElapsed + dt
    if shiftElapsed >= total then shiftActive = false end
  end

  clutchTarget = saturate(target)
  local rate = clutchTarget < clutchCommand
    and settings.clutchPressRate or settings.clutchReleaseRate
  setClutchOverride(moveTowards(clutchCommand, clutchTarget,
    math.max(rate, 0.1) * dt))
  if kind == 'action' and (clutchStatusKind ~= 'action' or clutchStatus ~= reason) then
    actionFlash = 1
  end
  clutchStatus, clutchStatusKind = reason, kind
  updateClutchHistory(car, raw, strongTurn)
end

-- Throttle camera runtime ----------------------------------------------------

local originalFov = nil
local baseSeat = nil
local throttleWasEnabled = false
local seatWasApplied = false
local fovWasApplied = false
local throttleResetCounter = nil
local throttleInput, steeringInput, throttleEffectScale = 0, 0, 0
local fovBlend, forwardBlend, renderedFovMix = 0, 0, 0
local renderedFov = settings.throttleRestingFov
local renderedForward, renderedVertical, renderedLateral = 0, 0, 0
local renderedPitch, renderedYaw = 0, 0
local outputForward, outputVertical, outputLateral = 0, 0, 0
local outputPitch, outputYaw = 0, 0
local throttleStatus = 'Waiting for cockpit view'

local function shapedThrottle(value)
  value = saturate(value or 0)
  local deadzone = clamp(settings.throttleDeadzone, 0, 0.50)
  if value <= deadzone then return 0 end
  local normalized = (value - deadzone) / math.max(1 - deadzone, 0.01)
  return math.pow(normalized, clamp(settings.throttleCurve, 0.25, 3.0))
end

local function normalizedMagnitude(value, amount)
  amount = math.abs(amount or 0)
  if amount < 0.0001 then return 0 end
  return saturate(math.abs(value or 0) / amount)
end

local function copySeat(params)
  if not params or not params.position then return nil end
  return {
    position = vec3(params.position.x, params.position.y, params.position.z),
    pitch = params.pitch or 0,
    yaw = params.yaw or 0
  }
end

local function captureBaseSeat()
  if baseSeat then return true end
  baseSeat = copySeat(ac.getOnboardCameraParams(PLAYER))
  return baseSeat ~= nil
end

local function resetThrottleMotion()
  throttleInput, steeringInput, throttleEffectScale = 0, 0, 0
  fovBlend, forwardBlend, renderedFovMix = 0, 0, 0
  renderedFov = clamp(settings.throttleRestingFov, 20, 170)
  renderedForward, renderedVertical, renderedLateral = 0, 0, 0
  renderedPitch, renderedYaw = 0, 0
  outputForward, outputVertical, outputLateral = 0, 0, 0
  outputPitch, outputYaw = 0, 0
end

local function restoreThrottleOutputs()
  if originalFov and fovWasApplied then ac.setFirstPersonCameraFOV(originalFov) end
  if baseSeat and seatWasApplied then
    ac.setOnboardCameraParams(PLAYER,
      ac.SeatParams(baseSeat.position, baseSeat.pitch, baseSeat.yaw), false)
  end
  fovWasApplied, seatWasApplied = false, false
end

local function applyCameraPose(forward, lateral, vertical, pitch, yaw)
  if not captureBaseSeat() then return end
  local position = vec3(
    baseSeat.position.x + settings.throttleStartX + lateral,
    baseSeat.position.y + settings.throttleStartY + vertical,
    baseSeat.position.z + settings.throttleStartZ + forward)
  ac.setOnboardCameraParams(PLAYER,
    ac.SeatParams(position,
      baseSeat.pitch + settings.throttleStartPitch + pitch,
      baseSeat.yaw + yaw), false)
  seatWasApplied = true
end

local function updateThrottleCamera(dt, car)
  local shouldEnable = settings.suiteEnabled and settings.throttleEnabled
  if not shouldEnable then
    if throttleWasEnabled then
      restoreThrottleOutputs()
      originalFov, baseSeat = nil, nil
      resetThrottleMotion()
    end
    throttleWasEnabled = false
    throttleStatus = settings.suiteEnabled and 'Throttle camera disabled' or 'Suite paused'
    return
  end

  if not throttleWasEnabled then
    originalFov = sim.firstPersonCameraFOV
    baseSeat = nil
    throttleResetCounter = car and car.resetCounter or nil
    resetThrottleMotion()
    throttleWasEnabled = true
  end

  local inCockpit = sim.cameraMode == ac.CameraMode.Cockpit and sim.focusedCar == PLAYER
  if not inCockpit then
    restoreThrottleOutputs()
    resetThrottleMotion()
    throttleStatus = 'Waiting for player cockpit view'
    return
  end
  if not car then
    throttleStatus = 'Waiting for player car'
    return
  end
  if throttleResetCounter ~= nil and car.resetCounter ~= throttleResetCounter then
    restoreThrottleOutputs()
    baseSeat = nil
    resetThrottleMotion()
  end
  throttleResetCounter = car.resetCounter
  if not captureBaseSeat() then
    throttleStatus = 'Seat API unavailable'
    return
  end

  throttleInput = shapedThrottle(car.gas)
  steeringInput = clamp((car.steer or 0) /
    math.max(settings.throttleSteeringAtFull, 30), -1, 1)
  local capKmh = math.max(settings.throttleEffectSpeedCap, 1)
  if settings.throttleEffectSpeedCapMph then capKmh = capKmh * 1.609344 end
  throttleEffectScale = saturate(math.abs(car.speedKmh or 0) / capKmh)
  local overall = clamp(settings.throttleOverallSpeed, 0.1, 3.0)

  local fovSpeed = throttleInput >= fovBlend
    and settings.throttleFovWidenSpeed or settings.throttleFovReturnSpeed
  fovBlend = expSmooth(fovBlend, throttleInput, fovSpeed * overall, dt)
  forwardBlend = expSmooth(forwardBlend, throttleInput,
    settings.throttleForwardSpeed * overall, dt)
  renderedForward = clamp(settings.throttleForwardDistance, -0.30, 0.30) * forwardBlend
  local throttleSteering = throttleInput * steeringInput
  renderedVertical = expSmooth(renderedVertical,
    throttleInput * clamp(settings.throttleVerticalDistance, -0.15, 0.15),
    settings.throttleVerticalSpeed * overall, dt)
  renderedLateral = expSmooth(renderedLateral,
    throttleSteering * clamp(settings.throttleLateralDistance, -0.15, 0.15),
    settings.throttleLateralSpeed * overall, dt)
  renderedPitch = expSmooth(renderedPitch,
    throttleInput * clamp(settings.throttlePitchAngle, -30, 30),
    settings.throttlePitchSpeed * overall, dt)
  renderedYaw = expSmooth(renderedYaw,
    throttleSteering * clamp(settings.throttleYawAngle, -45, 45),
    settings.throttleYawSpeed * overall, dt)

  local mixTarget = (
    forwardBlend * settings.throttleFovForwardMix
    + normalizedMagnitude(renderedVertical, settings.throttleVerticalDistance)
      * settings.throttleFovVerticalMix
    + normalizedMagnitude(renderedLateral, settings.throttleLateralDistance)
      * settings.throttleFovLateralMix
    + normalizedMagnitude(renderedPitch, settings.throttlePitchAngle)
      * settings.throttleFovPitchMix
    + normalizedMagnitude(renderedYaw, settings.throttleYawAngle)
      * settings.throttleFovYawMix
    + settings.throttleFovSpeedMix) * settings.throttleFovMixStrength
  local mixLimit = math.max(settings.throttleFovMixLimit, 0)
  mixTarget = clamp(mixTarget, -mixLimit, mixLimit)
  renderedFovMix = expSmooth(renderedFovMix, mixTarget,
    settings.throttleFovMixSpeed * overall, dt)

  outputForward = renderedForward * throttleEffectScale
  outputVertical = renderedVertical * throttleEffectScale
  outputLateral = renderedLateral * throttleEffectScale
  outputPitch = renderedPitch * throttleEffectScale
  outputYaw = renderedYaw * throttleEffectScale
  local restFov = clamp(settings.throttleRestingFov, 20, 170)
  local maxFov = clamp(math.max(settings.throttleMaximumFov, restFov), 20, 170)
  renderedFov = clamp(restFov
    + ((maxFov - restFov) * fovBlend + renderedFovMix) * throttleEffectScale,
    20, 170)
  ac.setFirstPersonCameraFOV(renderedFov)
  fovWasApplied = true
  applyCameraPose(outputForward, outputLateral, outputVertical, outputPitch, outputYaw)
  throttleStatus = 'Active in cockpit'
end

-- Presets and resets ---------------------------------------------------------

local function applyRoadClutchPreset()
  settings.clutchEnabled = true
  settings.clutchLaunchRPMPercent = 22
  settings.clutchAntiStallMargin = 420
  settings.clutchReleaseRate = 4.5
  settings.clutchShiftHold = 0.075
  settings.clutchShiftRelease = 0.17
  settings.clutchKickEnabled = false
end

local function applyDriftClutchPreset()
  settings.clutchEnabled = true
  settings.clutchLaunchRPMPercent = 30
  settings.clutchAntiStallMargin = 520
  settings.clutchReleaseRate = 6.5
  settings.clutchShiftHold = 0.065
  settings.clutchShiftRelease = 0.12
  settings.clutchKickEnabled = true
  settings.clutchKickRPMPercent = 52
  settings.clutchKickThrottle = 0.60
  settings.clutchKickSteer = 0.32
  settings.clutchKickMinSpeed = 18
  settings.clutchKickDuration = 0.09
  settings.clutchKickCooldown = 0.55
  settings.clutchKickRPMDrop = 500
end

local function applyThrottleSpeedPreset()
  settings.throttleEnabled = true
  settings.throttleOverallSpeed = 0.85
  settings.throttleRestingFov = 60
  settings.throttleMaximumFov = 75
  settings.throttleFovWidenSpeed = 4.0
  settings.throttleFovReturnSpeed = 3.0
  settings.throttleDeadzone = 0.02
  settings.throttleCurve = 1.10
  settings.throttleEffectSpeedCap = settings.throttleEffectSpeedCapMph and 62 or 100
  settings.throttleForwardDistance = -0.018
  settings.throttleForwardSpeed = 4.0
  settings.throttleVerticalDistance = -0.004
  settings.throttleVerticalSpeed = 5.0
  settings.throttleLateralDistance = 0.006
  settings.throttleLateralSpeed = 5.0
  settings.throttleSteeringAtFull = 360
  settings.throttlePitchAngle = 1.5
  settings.throttlePitchSpeed = 4.5
  settings.throttleYawAngle = 2.0
  settings.throttleYawSpeed = 4.5
  settings.throttleFovForwardMix = 2.5
  settings.throttleFovVerticalMix = 0.3
  settings.throttleFovLateralMix = 0.5
  settings.throttleFovPitchMix = 0.6
  settings.throttleFovYawMix = 0.4
  settings.throttleFovSpeedMix = 3.0
  settings.throttleFovMixStrength = 0.85
  settings.throttleFovMixSpeed = 4.0
  settings.throttleFovMixLimit = 8
  resetThrottleMotion()
end

local function applyNeckSpeedPreset()
  settings.neckEnabled = true
  settings.neckDynamicMovement = true
  settings.neckOverallSpeed = 0.85
  settings.neckGForceAtFull = 1.7
  settings.neckEffectSpeedCap = settings.neckEffectSpeedCapMph and 16 or 25
  settings.neckMoveXDistance, settings.neckMoveXSpeed = 0.024, 5.5
  settings.neckMoveYDistance, settings.neckMoveYSpeed = 0.007, 7.0
  settings.neckMoveZDistance, settings.neckMoveZSpeed = 0.030, 5.0
  settings.neckYawAngle, settings.neckYawSpeed = 5.5, 4.8
  settings.neckPitchAngle, settings.neckPitchSpeed = 4.5, 5.2
  settings.neckRollAngle, settings.neckRollSpeed = 5.5, 5.0
  settings.neckDriftYawAngle, settings.neckDriftYawSpeed = 7.5, 4.2
  settings.neckRoadPitchAngle, settings.neckRoadPitchSpeed = 2.5, 3.8
  settings.neckBankRollAngle, settings.neckBankRollSpeed = 4.0, 4.0
  settings.neckSpeedAngleStartKmh, settings.neckSpeedAngleFullKmh = 50, 220
  settings.neckSpeedPitchAngle, settings.neckSpeedPitchSpeed = 2.0, 4.0
  settings.neckSpeedYawAngle, settings.neckSpeedYawSpeed = 3.0, 4.2
  settings.neckSpeedRollAngle, settings.neckSpeedRollSpeed = 3.5, 4.2
  settings.neckHiddenJerkAtFull = 10
  settings.neckHiddenYawRateAtFull = 1.25
  settings.neckHiddenYawAngle, settings.neckHiddenYawSpeed = 1.3, 7.0
  settings.neckHiddenPitchAngle, settings.neckHiddenPitchSpeed = 1.1, 7.5
  settings.neckHiddenRollAngle, settings.neckHiddenRollSpeed = 1.4, 7.5
  settings.neckMixYawToRoll, settings.neckMixRollToYaw = 0.12, 0.06
  settings.neckMixPitchToRoll, settings.neckMixRollToPitch = 0.03, 0.06
  settings.neckMixXToZ, settings.neckMixZToX = 0.08, 0.06
  settings.neckMixYToZ, settings.neckMixZToY = 0.08, 0.10
  settings.neckSlideFollowing = true
  settings.neckSlidingLookMult = 0.45
  settings.neckTrackFollowing = true
  settings.neckTrackFollowingMult = 0.50
  settings.neckSteeringMult = 0.40
  settings.neckLookaheadDistance = 24
end

local function setStaticNeck()
  settings.neckDynamicMovement = false
  settings.neckSlideFollowing = false
  settings.neckTrackFollowing = false
  local zeroKeys = {
    'neckMoveXDistance', 'neckMoveYDistance', 'neckMoveZDistance',
    'neckYawAngle', 'neckPitchAngle', 'neckRollAngle',
    'neckDriftYawAngle', 'neckRoadPitchAngle', 'neckBankRollAngle',
    'neckSpeedPitchAngle', 'neckSpeedYawAngle', 'neckSpeedRollAngle',
    'neckHiddenYawAngle', 'neckHiddenPitchAngle', 'neckHiddenRollAngle',
    'neckMixYawToRoll', 'neckMixRollToYaw', 'neckMixPitchToRoll',
    'neckMixRollToPitch', 'neckMixXToZ', 'neckMixZToX',
    'neckMixYToZ', 'neckMixZToY', 'neckSlidingLookMult',
    'neckTrackFollowingMult', 'neckSteeringMult'
  }
  for _, key in ipairs(zeroKeys) do settings[key] = 0 end
end

local function matchThrottleSpeeds()
  local speed = settings.throttleForwardSpeed
  settings.throttleFovWidenSpeed = speed
  settings.throttleFovReturnSpeed = speed
  settings.throttleVerticalSpeed = speed
  settings.throttleLateralSpeed = speed
  settings.throttlePitchSpeed = speed
  settings.throttleYawSpeed = speed
  settings.throttleFovMixSpeed = speed
end

local function zeroThrottleStartPose()
  settings.throttleStartX, settings.throttleStartY = 0, 0
  settings.throttleStartZ, settings.throttleStartPitch = 0, 0
end

local function applyRoadSuitePreset()
  settings.suiteEnabled = true
  applyRoadClutchPreset()
  applyThrottleSpeedPreset()
  applyNeckSpeedPreset()
end

local function applyDriftSuitePreset()
  settings.suiteEnabled = true
  applyDriftClutchPreset()
  applyThrottleSpeedPreset()
  applyNeckSpeedPreset()
  settings.neckTrackFollowingMult = 0.35
  settings.neckSlidingLookMult = 0.70
  settings.neckDriftYawAngle = 10
end

function script.update(dt)
  dt = clamp(dt or 0, 0, 0.05)
  elapsedTime = elapsedTime + dt
  actionFlash = math.max(0, actionFlash - dt * 1.8)
  syncNeckLink()
  local car = ac.getCar(PLAYER)
  updateAdaptiveClutch(dt, car)
  updateThrottleCamera(dt, car)
end

ac.onRelease(function()
  releaseClutch('App unloaded')
  restoreThrottleOutputs()
end)

-- Dashboard UI ---------------------------------------------------------------

local THEME_NAMES = { 'Corsa Red', 'Electric Blue', 'Apex Green', 'Sunset Amber' }
local THEME_ACCENTS = {
  rgbm(0.95, 0.06, 0.085, 1),
  rgbm(0.12, 0.58, 1.00, 1),
  rgbm(0.12, 0.88, 0.52, 1),
  rgbm(1.00, 0.52, 0.08, 1)
}

local COLOR_TEXT = rgbm(0.96, 0.97, 0.98, 1)
local COLOR_MUTED = rgbm(0.52, 0.56, 0.62, 1)
local COLOR_ACTIVE = rgbm(0.25, 0.93, 0.55, 1)
local COLOR_ACTION = rgbm(1.00, 0.69, 0.20, 1)
local COLOR_WARNING = rgbm(1.00, 0.34, 0.25, 1)
local resetEverythingArmed = false

local function accentColor(alpha)
  local index = clamp(math.floor(settings.colorTheme + 0.5), 1, #THEME_ACCENTS)
  local color = THEME_ACCENTS[index]
  return rgbm(color.r, color.g, color.b, alpha or 1)
end

local function clutchStateColor()
  if clutchStatusKind == 'action' then return COLOR_ACTION end
  if clutchStatusKind == 'warning' then return COLOR_WARNING end
  if clutchStatusKind == 'active' then return COLOR_ACTIVE end
  return COLOR_MUTED
end

local function neckIsOnline()
  return neckLink.backendPresent and os.preciseClock() - neckLastAckTime < 1.5
end

local function toggle(label, key, tooltip)
  if ui.checkbox(label, settings[key]) then settings[key] = not settings[key] end
  if tooltip and ui.itemHovered() then ui.setTooltip(tooltip) end
end

local function slider(label, key, minimum, maximum, format, tooltip)
  local value = ui.slider(label, settings[key], minimum, maximum, format)
  if ui.itemEdited() then settings[key] = value end
  if ui.itemClicked(ui.MouseButton.Right) and DEFAULTS[key] ~= nil then
    settings[key] = DEFAULTS[key]
  end
  if ui.itemHovered() then
    ui.setTooltip(tooltip or 'Right-click to reset this value to its original default.')
  end
end

local function section(title, description)
  ui.separator()
  ui.textColored(title, accentColor())
  if description then ui.textWrapped(description) end
end

local function tabButton(current, page, label, width)
  local selected = current == page
  local text = selected and ('[ ' .. label .. ' ]') or label
  if ui.button(text, vec2(width or 90, 25)) then return page end
  return current
end

local function drawMainChrome()
  local size = ui.windowSize()
  local accent = accentColor()
  ui.setCursor(vec2(0, 0))
  ui.dummy(vec2(1, 1))
  ui.drawRectFilledMultiColor(vec2(0, 0), size,
    rgbm(0.035, 0.038, 0.047, 0.99), rgbm(0.018, 0.020, 0.026, 0.99),
    rgbm(0.008, 0.009, 0.012, 0.99), rgbm(0.008, 0.009, 0.012, 0.99))
  ui.drawRectFilled(vec2(0, 0), vec2(size.x, 4), accent)
  ui.drawRectFilled(vec2(10, 27), vec2(size.x - 10, 75),
    rgbm(accent.r, accent.g, accent.b, 0.075), 8)
  ui.drawRect(vec2(10, 27), vec2(size.x - 10, 75),
    rgbm(accent.r, accent.g, accent.b, 0.34), 8, 0, 1)
  ui.pushDWriteFont('@System;Weight=Black;Stretch=Condensed')
  ui.dwriteDrawTextClipped('CPC DRIVE SUITE', 23 * settings.uiScale,
    vec2(21, 29), vec2(size.x - 185, 57), ui.Alignment.Start,
    ui.Alignment.Center, false, COLOR_TEXT)
  ui.popDWriteFont()
  ui.drawText('CLUTCH  /  THROTTLE CAMERA  /  DYNAMIC 6DOF',
    vec2(22, 57), COLOR_MUTED)
  local stateColor = settings.suiteEnabled and COLOR_ACTIVE or COLOR_WARNING
  local stateText = settings.suiteEnabled and 'RUNNING' or 'PAUSED'
  local stateP1, stateP2 = vec2(size.x - 153, 37), vec2(size.x - 22, 65)
  ui.drawRectFilled(stateP1, stateP2,
    rgbm(stateColor.r, stateColor.g, stateColor.b, 0.13), 12)
  ui.drawRect(stateP1, stateP2, stateColor, 12, 0, 1)
  ui.drawTextClipped(stateText, stateP1, stateP2, stateColor,
    vec2(0.5, 0.5), false)
  ui.setCursor(vec2(18, 84))
end

local function drawPrimaryTabs()
  local gap = 5
  local available = ui.availableSpaceX()
  local width = math.max(82, (available - gap * 4) / 5)
  settings.uiPage = tabButton(settings.uiPage, 1, 'HOME', width)
  ui.sameLine(0, gap)
  settings.uiPage = tabButton(settings.uiPage, 2, 'CLUTCH', width)
  ui.sameLine(0, gap)
  settings.uiPage = tabButton(settings.uiPage, 3, 'THROTTLE', width)
  ui.sameLine(0, gap)
  settings.uiPage = tabButton(settings.uiPage, 4, 'NECKFX', width)
  ui.sameLine(0, gap)
  settings.uiPage = tabButton(settings.uiPage, 5, 'LOOK', width)
  ui.progressBar((settings.uiPage - 1) / 4, vec2(ui.availableSpaceX(), 3), '')
end

local function drawHomePage()
  section('MASTER CONTROL', 'Pause every output instantly while keeping all tuning saved.')
  toggle('Enable CPC Drive Suite', 'suiteEnabled')

  section('SYSTEMS')
  toggle('Adaptive clutch assist', 'clutchEnabled',
    'Controls clutch coupling only. A physical pedal can always press farther.')
  ui.sameLine()
  ui.textColored(clutchStatus, clutchStateColor())
  toggle('Throttle seat and FOV camera', 'throttleEnabled',
    'Directly edits cockpit seat position and first-person FOV.')
  ui.sameLine()
  ui.textColored(throttleStatus,
    throttleStatus == 'Active in cockpit' and COLOR_ACTIVE or COLOR_MUTED)
  toggle('Dynamic 6DOF NeckFX layer', 'neckEnabled',
    'Requires the CPC Drive Suite cockpit-camera backend to be selected in NeckFX.')
  ui.sameLine()
  ui.textColored(neckIsOnline() and 'BACKEND ONLINE' or 'BACKEND OFFLINE',
    neckIsOnline() and COLOR_ACTIVE or COLOR_WARNING)

  section('QUICK START PRESETS',
    'Presets change tuning, not your saved starting seat offsets or HUD appearance.')
  local presetWidth = math.max(130, (ui.availableSpaceX() - 10) / 3)
  if ui.button('ROAD / CIRCUIT', vec2(presetWidth, 30)) then applyRoadSuitePreset() end
  ui.sameLine(0, 5)
  if ui.button('DRIFT / TRANSITION', vec2(presetWidth, 30)) then applyDriftSuitePreset() end
  ui.sameLine(0, 5)
  if ui.button('SPEED G-FORCE', vec2(presetWidth, 30)) then
    applyThrottleSpeedPreset()
    applyNeckSpeedPreset()
  end

  section('LIVE DRIVE')
  ui.progressBar(saturate((telemetry.rpm - telemetry.idleRPM) /
    math.max(telemetry.limiterRPM - telemetry.idleRPM, 1)),
    vec2(ui.availableSpaceX(), 18),
    string.format('RPM %.0f / %.0f  |  %+.0f RPM/s',
      telemetry.rpm, telemetry.limiterRPM, rpmTrend))
  ui.progressBar(clutchCommand, vec2(ui.availableSpaceX(), 18),
    string.format('Clutch coupled %.0f%%  |  Target %.0f%%  |  Physical %.0f%%',
      clutchCommand * 100, clutchTarget * 100, telemetry.rawClutch * 100))
  ui.text(string.format('Gas %.0f%%   Brake %.0f%%   Wheel %+.0f%%   Speed %.1f km/h   Gear %d',
    telemetry.gas * 100, telemetry.brake * 100, telemetry.steer * 100,
    telemetry.speed, telemetry.gear))
  ui.text(string.format('Throttle camera: FOV %.1f deg   XYZ %+.1f / %+.1f / %+.1f mm',
    renderedFov, outputLateral * 1000, outputVertical * 1000, outputForward * 1000))
  ui.text(string.format('NeckFX: %.0f%% strength   XYZ %+.1f / %+.1f / %+.1f mm',
    neckTelemetry.effectStrength * 100, neckTelemetry.outputX * 1000,
    neckTelemetry.outputY * 1000, neckTelemetry.outputZ * 1000))

  section('SETUP CHECK')
  if telemetry.builtInAutoClutch then
    ui.textColored('Turn off AC built-in auto-clutch to avoid overlapping clutch assists.',
      COLOR_WARNING)
  else
    ui.textColored('AC built-in auto-clutch is not reporting a conflict.', COLOR_ACTIVE)
  end
  if not neckIsOnline() then
    ui.textColored('Select CPC Drive Suite - NeckFX Backend, enable scripted NeckFX, then reload.',
      COLOR_WARNING)
  else
    ui.textColored('The separate NeckFX runtime is connected to this dashboard.', COLOR_ACTIVE)
  end
  ui.textWrapped('If another app directly edits cockpit seat position or FOV, disable it. NeckFX remains compatible because CSP applies it as a separate camera layer.')
end

local function drawClutchPage()
  section('ADAPTIVE CLUTCH')
  toggle('Enable clutch assist', 'clutchEnabled')
  ui.sameLine()
  ui.textColored(clutchStatus, clutchStateColor())
  ui.progressBar(1 - math.min(telemetry.rawClutch, clutchCommand),
    vec2(ui.availableSpaceX(), 18),
    string.format('Effective clutch pressed %.0f%%',
      (1 - math.min(telemetry.rawClutch, clutchCommand)) * 100))

  local width = math.max(115, (ui.availableSpaceX() - 10) / 3)
  settings.clutchPage = tabButton(settings.clutchPage, 1, 'ASSISTS', width)
  ui.sameLine(0, 5)
  settings.clutchPage = tabButton(settings.clutchPage, 2, 'LAUNCH', width)
  ui.sameLine(0, 5)
  settings.clutchPage = tabButton(settings.clutchPage, 3, 'SHIFT + KICK', width)

  if settings.clutchPage == 1 then
    section('CORE ASSISTS')
    toggle('Adaptive standing launch', 'clutchLaunchEnabled')
    toggle('Predictive anti-stall', 'clutchAntiStallEnabled')
    toggle('Automatic clutch on shifts', 'clutchShiftEnabled')
    toggle('Use wheel angle for low-speed engine load', 'clutchTurnAware')
    toggle('Turn-transition / drift clutch kick', 'clutchKickEnabled')

    section('LIVE DIAGNOSIS')
    local rpmDirection = rpmTrend > 120 and 'RISING'
      or (rpmTrend < -120 and 'FALLING' or 'STEADY')
    ui.text(string.format('RPM %.0f   %s %+.0f RPM/s', telemetry.rpm, rpmDirection, rpmTrend))
    ui.text(string.format('Launch target %.0f RPM   Kick ceiling %.0f RPM',
      telemetry.launchRPM, telemetry.kickRPM))
    ui.text(string.format('Command %.3f   Target %.3f   Physical pedal %.3f',
      clutchCommand, clutchTarget, telemetry.rawClutch))
    ui.textWrapped('Clutch polarity is coupled at 100% and pressed at 0%. CSP combines this command with the physical pedal using the lower value, so the driver retains priority.')

  elseif settings.clutchPage == 2 then
    section('STANDING LAUNCH',
      'Road speed and RPM jointly control how quickly the clutch couples.')
    slider('Launch RPM (% usable range)', 'clutchLaunchRPMPercent', 10, 50, '%.0f%%')
    slider('Launch complete speed', 'clutchLaunchEndSpeed', 5, 35, '%.1f km/h')
    slider('Launch throttle threshold', 'clutchLaunchThrottle', 0.02, 0.50, '%.2f')

    section('PREDICTIVE ANTI-STALL',
      'Falling RPM is projected forward; wheel angle and brake load can add safety margin.')
    slider('RPM margin above idle', 'clutchAntiStallMargin', 150, 1000, '%.0f RPM')
    slider('Maximum anti-stall speed', 'clutchAntiStallSpeed', 10, 80, '%.0f km/h')
    slider('RPM prediction time', 'clutchRPMLookahead', 0.02, 0.35, '%.2f s')
    slider('Brake hold threshold', 'clutchBrakeThreshold', 0.02, 0.70, '%.2f')
    slider('Wheel load starts at', 'clutchTurnLoadStart', 0.05, 0.80, '%.2f')
    slider('Extra turning RPM margin', 'clutchTurnExtraMargin', 0, 900, '%.0f RPM')

  else
    section('CLUTCH TIMING')
    slider('Press speed', 'clutchPressRate', 4, 40, '%.1f /s')
    slider('Release speed', 'clutchReleaseRate', 1, 16, '%.1f /s')
    slider('Shift clutch hold', 'clutchShiftHold', 0.03, 0.25, '%.3f s')
    slider('Shift release time', 'clutchShiftRelease', 0.04, 0.45, '%.3f s')

    section('TURN / DRIFT KICK',
      'A short clutch pulse can fire on falling RPM or a left/right wheel transition.')
    toggle('Enable drift clutch kick', 'clutchKickEnabled')
    slider('Kick below RPM (% usable range)', 'clutchKickRPMPercent', 20, 85, '%.0f%%')
    slider('Minimum throttle', 'clutchKickThrottle', 0.20, 1.00, '%.2f')
    slider('Minimum wheel input', 'clutchKickSteer', 0.08, 0.95, '%.2f')
    slider('Minimum road speed', 'clutchKickMinSpeed', 5, 100, '%.0f km/h')
    slider('Kick duration', 'clutchKickDuration', 0.03, 0.22, '%.3f s')
    slider('Kick cooldown', 'clutchKickCooldown', 0.20, 2.00, '%.2f s')
    slider('Falling-RPM trigger', 'clutchKickRPMDrop', 100, 2500, '%.0f RPM/s')
  end

  section('CLUTCH PRESETS')
  if ui.button('ROAD / CIRCUIT', vec2(145, 0)) then applyRoadClutchPreset() end
  ui.sameLine()
  if ui.button('DRIFT / TRANSITION', vec2(165, 0)) then applyDriftClutchPreset() end
  ui.sameLine()
  if ui.button('RESET CLUTCH') then
    copyDefaultsWithPrefix('clutch')
    resetClutchRuntime(ac.getCar(PLAYER))
  end
end

local function drawThrottlePage()
  section('THROTTLE CAMERA')
  toggle('Enable throttle seat and FOV camera', 'throttleEnabled')
  ui.sameLine()
  ui.textColored(throttleStatus,
    throttleStatus == 'Active in cockpit' and COLOR_ACTIVE or COLOR_MUTED)

  local width = math.max(85, (ui.availableSpaceX() - 15) / 4)
  settings.throttlePage = tabButton(settings.throttlePage, 1, 'MASTER', width)
  ui.sameLine(0, 5)
  settings.throttlePage = tabButton(settings.throttlePage, 2, 'POSITION', width)
  ui.sameLine(0, 5)
  settings.throttlePage = tabButton(settings.throttlePage, 3, 'ANGLES', width)
  ui.sameLine(0, 5)
  settings.throttlePage = tabButton(settings.throttlePage, 4, 'FOV + MIX', width)

  if settings.throttlePage == 1 then
    section('MASTER RESPONSE')
    slider('Overall effects speed', 'throttleOverallSpeed', 0.1, 3.0, '%.1fx')
    slider('Throttle deadzone', 'throttleDeadzone', 0, 0.20, '%.3f')
    slider('Throttle response curve', 'throttleCurve', 0.25, 3.0, '%.2f',
      'Below 1 responds earlier; above 1 stays softer until high throttle. Right-click resets.')
    toggle('Use mph for effects cap', 'throttleEffectSpeedCapMph')
    local unit = settings.throttleEffectSpeedCapMph and 'mph' or 'km/h'
    slider('Effects reach full at', 'throttleEffectSpeedCap', 1,
      settings.throttleEffectSpeedCapMph and 120 or 200, '%.0f ' .. unit)
    ui.textWrapped('Every dynamic FOV, position and angle channel fades in with road speed. Starting seat offsets remain fixed.')

    section('LIVE OUTPUT')
    ui.text(string.format('Throttle / steering: %.0f%% / %+.0f%%',
      throttleInput * 100, steeringInput * 100))
    ui.text(string.format('Speed strength: %.0f%%   Current FOV: %.1f deg',
      throttleEffectScale * 100, renderedFov))
    ui.text(string.format('Position X/Y/Z: %+.1f / %+.1f / %+.1f mm',
      outputLateral * 1000, outputVertical * 1000, outputForward * 1000))
    ui.text(string.format('Pitch / yaw: %+.2f / %+.2f deg   FOV mix: %+.2f deg',
      outputPitch, outputYaw, renderedFovMix * throttleEffectScale))

  elseif settings.throttlePage == 2 then
    section('STARTING HEAD POSE',
      'Offsets are relative to the car saved seat and remain active at zero throttle.')
    slider('Start X - left / right', 'throttleStartX', -0.30, 0.30, '%+.3f m')
    slider('Start Y - down / up', 'throttleStartY', -0.30, 0.30, '%+.3f m')
    slider('Start Z - back / forward', 'throttleStartZ', -0.50, 0.50, '%+.3f m')
    slider('Start pitch - down / up', 'throttleStartPitch', -30, 30, '%+.1f deg')
    if ui.button('ZERO STARTING POSE') then zeroThrottleStartPose() end

    section('THROTTLE POSITION MOTION')
    slider('Z forward / back distance', 'throttleForwardDistance', -0.30, 0.30, '%+.3f m')
    slider('Z response speed', 'throttleForwardSpeed', 0.5, 30, '%.1f')
    slider('Y vertical distance', 'throttleVerticalDistance', -0.15, 0.15, '%+.3f m')
    slider('Y response speed', 'throttleVerticalSpeed', 0.5, 30, '%.1f')
    slider('X lateral distance', 'throttleLateralDistance', -0.15, 0.15, '%+.3f m')
    slider('X response speed', 'throttleLateralSpeed', 0.5, 30, '%.1f')
    slider('Full steering effect at', 'throttleSteeringAtFull', 90, 720, '%.0f deg')

  elseif settings.throttlePage == 3 then
    section('THROTTLE PITCH')
    slider('Pitch angle', 'throttlePitchAngle', -30, 30, '%+.1f deg')
    slider('Pitch response speed', 'throttlePitchSpeed', 0.5, 30, '%.1f')
    ui.textWrapped('Positive or negative values reverse the pitch direction.')

    section('THROTTLE + STEERING YAW')
    slider('Yaw angle', 'throttleYawAngle', -45, 45, '%+.1f deg')
    slider('Yaw response speed', 'throttleYawSpeed', 0.5, 30, '%.1f')
    ui.textWrapped('Yaw combines shaped throttle with steering direction.')

    section('SPEED SYNCHRONIZATION')
    if ui.button('MATCH EVERY RESPONSE SPEED TO Z') then matchThrottleSpeeds() end
    ui.textWrapped('This keeps FOV, X/Y/Z, pitch, yaw and mixed FOV response synchronized with forward/back motion.')

  else
    section('BASE FOV')
    slider('Resting / low FOV', 'throttleRestingFov', 20, 140, '%.1f deg')
    if settings.throttleMaximumFov < settings.throttleRestingFov then
      settings.throttleMaximumFov = settings.throttleRestingFov
    end
    slider('Full-throttle FOV', 'throttleMaximumFov',
      settings.throttleRestingFov, 170, '%.1f deg')
    slider('FOV widen speed', 'throttleFovWidenSpeed', 0.5, 30, '%.1f')
    slider('FOV return speed', 'throttleFovReturnSpeed', 0.5, 30, '%.1f')

    section('POSITION AND ANGLE TO FOV')
    slider('Forward motion into FOV', 'throttleFovForwardMix', -20, 20, '%+.1f deg')
    slider('Vertical motion into FOV', 'throttleFovVerticalMix', -10, 10, '%+.1f deg')
    slider('Lateral motion into FOV', 'throttleFovLateralMix', -10, 10, '%+.1f deg')
    slider('Pitch into FOV', 'throttleFovPitchMix', -10, 10, '%+.1f deg')
    slider('Yaw into FOV', 'throttleFovYawMix', -10, 10, '%+.1f deg')
    slider('Vehicle speed into FOV', 'throttleFovSpeedMix', -20, 20, '%+.1f deg')

    section('FOV MIX MASTER')
    slider('Mixed FOV strength', 'throttleFovMixStrength', 0, 2, '%.2fx')
    slider('Mixed FOV response speed', 'throttleFovMixSpeed', 0.5, 30, '%.1f')
    slider('Maximum mixed FOV offset', 'throttleFovMixLimit', 0, 40, '%.1f deg')
  end

  section('THROTTLE CAMERA CONTROLS')
  if ui.button('SPEED G-FORCE PRESET') then applyThrottleSpeedPreset() end
  ui.sameLine()
  if ui.button('RETURN TO REST') then
    resetThrottleMotion()
    if settings.throttleEnabled and sim.cameraMode == ac.CameraMode.Cockpit then
      ac.setFirstPersonCameraFOV(clamp(settings.throttleRestingFov, 20, 170))
      fovWasApplied = true
      applyCameraPose(0, 0, 0, 0, 0)
    end
  end
  ui.sameLine()
  if ui.button('RESET THROTTLE') then
    copyDefaultsWithPrefix('throttle')
    resetThrottleMotion()
  end
end

local function drawNeckPage()
  section('DYNAMIC 6DOF NECKFX')
  toggle('Enable NeckFX output', 'neckEnabled')
  ui.sameLine()
  ui.textColored(neckIsOnline() and 'BACKEND ONLINE' or 'BACKEND OFFLINE',
    neckIsOnline() and COLOR_ACTIVE or COLOR_WARNING)

  local width = math.max(70, (ui.availableSpaceX() - 20) / 5)
  settings.neckPage = tabButton(settings.neckPage, 1, 'MASTER', width)
  ui.sameLine(0, 5)
  settings.neckPage = tabButton(settings.neckPage, 2, 'POSITION', width)
  ui.sameLine(0, 5)
  settings.neckPage = tabButton(settings.neckPage, 3, 'ROTATION', width)
  ui.sameLine(0, 5)
  settings.neckPage = tabButton(settings.neckPage, 4, 'DYNAMIC', width)
  ui.sameLine(0, 5)
  settings.neckPage = tabButton(settings.neckPage, 5, 'MIX + DIR', width)

  if settings.neckPage == 1 then
    section('MASTER EFFECTS')
    toggle('Enable all six dynamic axes', 'neckDynamicMovement')
    slider('Overall effects speed', 'neckOverallSpeed', 0.1, 3.0, '%.1fx')
    slider('Full movement at G-force', 'neckGForceAtFull', 0.5, 4.0, '%.1f G')
    toggle('Use mph for effects cap', 'neckEffectSpeedCapMph')
    local unit = settings.neckEffectSpeedCapMph and 'mph' or 'km/h'
    slider('Effects reach full at', 'neckEffectSpeedCap', 1,
      settings.neckEffectSpeedCapMph and 120 or 200, '%.0f ' .. unit)
    ui.textWrapped('Overall speed multiplies every individual response speed plus slide, steering and track-following response. Amounts remain unchanged.')

    section('LIVE BACKEND OUTPUT')
    ui.progressBar(neckTelemetry.effectStrength, vec2(ui.availableSpaceX(), 18),
      string.format('Road-speed effect strength %.0f%%', neckTelemetry.effectStrength * 100))
    ui.text(string.format('Position X/Y/Z: %+.1f / %+.1f / %+.1f mm',
      neckTelemetry.outputX * 1000, neckTelemetry.outputY * 1000,
      neckTelemetry.outputZ * 1000))
    ui.text(string.format('Yaw / pitch / roll: %+.2f / %+.2f / %+.2f deg',
      neckTelemetry.outputYaw, neckTelemetry.outputPitch, neckTelemetry.outputRoll))
    ui.text(string.format('Car acceleration X/Y/Z: %+.2f / %+.2f / %+.2f G',
      telemetry.accelerationX, telemetry.accelerationY, telemetry.accelerationZ))
    if not neckIsOnline() then
      ui.textColored('Select CPC Drive Suite - NeckFX Backend in CSP and reload the session.',
        COLOR_WARNING)
    end

  elseif settings.neckPage == 2 then
    section('X — LATERAL HEAD MOVEMENT')
    slider('X movement distance', 'neckMoveXDistance', 0, 0.15, '%.3f m')
    slider('X response speed', 'neckMoveXSpeed', 0.5, 30, '%.1f')
    section('Y — VERTICAL HEAD MOVEMENT')
    slider('Y movement distance', 'neckMoveYDistance', 0, 0.10, '%.3f m')
    slider('Y response speed', 'neckMoveYSpeed', 0.5, 30, '%.1f')
    section('Z — FORWARD / BACK MOVEMENT')
    slider('Z movement distance', 'neckMoveZDistance', 0, 0.15, '%.3f m')
    slider('Z response speed', 'neckMoveZSpeed', 0.5, 30, '%.1f')

  elseif settings.neckPage == 3 then
    section('PRIMARY ROTATION')
    slider('Yaw angle', 'neckYawAngle', 0, 45, '%.1f deg')
    slider('Yaw response speed', 'neckYawSpeed', 0.5, 30, '%.1f')
    slider('Pitch angle', 'neckPitchAngle', 0, 30, '%.1f deg')
    slider('Pitch response speed', 'neckPitchSpeed', 0.5, 30, '%.1f')
    slider('Roll angle', 'neckRollAngle', 0, 45, '%.1f deg')
    slider('Roll response speed', 'neckRollSpeed', 0.5, 30, '%.1f')

    section('EXTRA ROAD AND SLIDE ROTATION')
    slider('Drift yaw angle', 'neckDriftYawAngle', 0, 45, '%.1f deg')
    slider('Drift yaw response', 'neckDriftYawSpeed', 0.5, 30, '%.1f')
    slider('Road elevation pitch', 'neckRoadPitchAngle', 0, 30, '%.1f deg')
    slider('Road pitch response', 'neckRoadPitchSpeed', 0.5, 30, '%.1f')
    slider('Track banking roll', 'neckBankRollAngle', 0, 45, '%.1f deg')
    slider('Banking roll response', 'neckBankRollSpeed', 0.5, 30, '%.1f')

  elseif settings.neckPage == 4 then
    section('HIGH-SPEED ANGLE WINDOW')
    slider('Speed angles begin', 'neckSpeedAngleStartKmh', 0, 200, '%.0f km/h')
    if settings.neckSpeedAngleFullKmh <= settings.neckSpeedAngleStartKmh then
      settings.neckSpeedAngleFullKmh = settings.neckSpeedAngleStartKmh + 10
    end
    slider('Speed angles reach full', 'neckSpeedAngleFullKmh',
      settings.neckSpeedAngleStartKmh + 10, 400, '%.0f km/h')
    slider('Speed pitch angle', 'neckSpeedPitchAngle', -30, 30, '%+.1f deg')
    slider('Speed pitch response', 'neckSpeedPitchSpeed', 0.5, 30, '%.1f')
    slider('Speed yaw angle', 'neckSpeedYawAngle', -45, 45, '%+.1f deg')
    slider('Speed yaw response', 'neckSpeedYawSpeed', 0.5, 30, '%.1f')
    slider('Speed roll angle', 'neckSpeedRollAngle', -45, 45, '%+.1f deg')
    slider('Speed roll response', 'neckSpeedRollSpeed', 0.5, 30, '%.1f')

    section('HIDDEN TRANSIENT NECK LAG')
    slider('Full response at acceleration jerk', 'neckHiddenJerkAtFull', 1, 30, '%.1f G/s')
    slider('Full response at yaw rate', 'neckHiddenYawRateAtFull', 0.2, 3.0, '%.1f rad/s')
    slider('Hidden yaw angle', 'neckHiddenYawAngle', -20, 20, '%+.1f deg')
    slider('Hidden yaw response', 'neckHiddenYawSpeed', 0.5, 30, '%.1f')
    slider('Hidden pitch angle', 'neckHiddenPitchAngle', -20, 20, '%+.1f deg')
    slider('Hidden pitch response', 'neckHiddenPitchSpeed', 0.5, 30, '%.1f')
    slider('Hidden roll angle', 'neckHiddenRollAngle', -20, 20, '%+.1f deg')
    slider('Hidden roll response', 'neckHiddenRollSpeed', 0.5, 30, '%.1f')

  else
    section('NON-RECURSIVE ANGLE MIXES')
    slider('Yaw into roll', 'neckMixYawToRoll', -2, 2, '%+.2f')
    slider('Roll into yaw', 'neckMixRollToYaw', -2, 2, '%+.2f')
    slider('Pitch into roll', 'neckMixPitchToRoll', -2, 2, '%+.2f')
    slider('Roll into pitch', 'neckMixRollToPitch', -2, 2, '%+.2f')
    section('NON-RECURSIVE POSITION MIXES')
    slider('X lateral into Z forward/back', 'neckMixXToZ', -2, 2, '%+.2f')
    slider('Z forward/back into X lateral', 'neckMixZToX', -2, 2, '%+.2f')
    slider('Y vertical into Z forward/back', 'neckMixYToZ', -2, 2, '%+.2f')
    slider('Z forward/back into Y vertical', 'neckMixZToY', -2, 2, '%+.2f')

    section('DIRECTION FOLLOWING')
    toggle('Follow car sliding direction', 'neckSlideFollowing')
    slider('Slide following amount', 'neckSlidingLookMult', 0, 1.5, '%.2f')
    toggle('Follow track trajectory', 'neckTrackFollowing')
    slider('Track following amount', 'neckTrackFollowingMult', 0, 1.5, '%.2f')
    slider('Track look-ahead distance', 'neckLookaheadDistance', 5, 50, '%.0f m')
    slider('Steering fallback amount', 'neckSteeringMult', 0, 2, '%.2f')
  end

  section('NECKFX CONTROLS')
  if ui.button('SPEED G-FORCE PRESET') then applyNeckSpeedPreset() end
  ui.sameLine()
  if ui.button('STATIC HEAD') then setStaticNeck() end
  ui.sameLine()
  if ui.button('RESET NECKFX') then copyDefaultsWithPrefix('neck') end
end

local function drawAppearancePage()
  section('COLOR THEME', 'The selected accent applies to both dashboard and HUD.')
  local themeWidth = math.max(105, (ui.availableSpaceX() - 5) / 2)
  for index, name in ipairs(THEME_NAMES) do
    local selected = settings.colorTheme == index
    if ui.button((selected and '[ ' or '') .. name .. (selected and ' ]' or ''),
        vec2(themeWidth, 28)) then
      settings.colorTheme = index
    end
    if index % 2 == 1 then ui.sameLine(0, 5) end
  end
  slider('Dashboard title scale', 'uiScale', 0.80, 1.30, '%.2fx')

  section('HUD LAYOUT')
  local layoutWidth = math.max(105, (ui.availableSpaceX() - 10) / 3)
  settings.hudMode = tabButton(settings.hudMode, 1, 'FULL', layoutWidth)
  ui.sameLine(0, 5)
  settings.hudMode = tabButton(settings.hudMode, 2, 'INPUTS', layoutWidth)
  ui.sameLine(0, 5)
  settings.hudMode = tabButton(settings.hudMode, 3, 'MINIMAL', layoutWidth)
  slider('HUD background opacity', 'hudOpacity', 0.25, 1.0, '%.2f')
  slider('HUD animation strength', 'hudAnimation', 0, 1.5, '%.2fx')
  toggle('Display road speed in mph', 'hudSpeedMph')

  section('HUD SECTIONS')
  toggle('Show RPM strip', 'hudShowRPM')
  toggle('Show steering wheel', 'hudShowWheel')
  toggle('Show pedal graphics', 'hudShowPedals')
  toggle('Show camera output panel', 'hudShowCamera')
  toggle('Show status ribbon', 'hudShowStatus')
  ui.textWrapped('The HUD is fully resizable. Full shows every camera and input channel, Inputs focuses on wheel and pedals, and Minimal keeps only RPM, gear, speed and intervention status.')

  section('RESET AND SAFETY')
  if ui.button('RESET HUD APPEARANCE') then
    local keys = {
      'colorTheme', 'uiScale', 'hudMode', 'hudOpacity', 'hudAnimation',
      'hudSpeedMph', 'hudShowWheel', 'hudShowPedals', 'hudShowCamera',
      'hudShowRPM', 'hudShowStatus'
    }
    for _, key in ipairs(keys) do settings[key] = DEFAULTS[key] end
  end
  ui.sameLine()
  if not resetEverythingArmed then
    if ui.button('RESET EVERYTHING') then resetEverythingArmed = true end
  else
    if ui.button('CONFIRM FULL RESET') then
      for key, value in pairs(DEFAULTS) do settings[key] = value end
      settings.settingsVersion = 1
      resetClutchRuntime(ac.getCar(PLAYER))
      resetThrottleMotion()
      resetEverythingArmed = false
    end
    ui.sameLine()
    if ui.button('CANCEL') then resetEverythingArmed = false end
  end
  if resetEverythingArmed then
    ui.textColored('Confirming will replace every saved suite value.', COLOR_WARNING)
  else
    ui.textDisabled('Full reset needs a second confirmation and only changes this suite settings.')
  end

  section('ABOUT')
  ui.text('CPC Drive Suite 3.0.1')
  ui.textWrapped('One app replaces Adaptive Wheel Clutch, CPC Throttle Camera and CPC Dynamic 6DOF. The cockpit-camera file is a required NeckFX backend, not a separate shelf app.')
end

function script.windowMain(dt)
  drawMainChrome()
  drawPrimaryTabs()
  if settings.uiPage == 1 then drawHomePage()
  elseif settings.uiPage == 2 then drawClutchPage()
  elseif settings.uiPage == 3 then drawThrottlePage()
  elseif settings.uiPage == 4 then drawNeckPage()
  else drawAppearancePage() end
  ui.setCursorX(18)
  ui.dummy(vec2(1, 12))
end

-- Custom telemetry HUD -------------------------------------------------------

local function hudContext(baseHeight)
  local size = ui.windowSize()
  local scale = math.min(size.x / 720, size.y / baseHeight)
  local origin = vec2((size.x - 720 * scale) * 0.5,
    (size.y - baseHeight * scale) * 0.5)
  return { size = size, scale = scale, origin = origin, baseHeight = baseHeight }
end

local function hudPoint(ctx, x, y)
  return ctx.origin + vec2(x * ctx.scale, y * ctx.scale)
end

local function hudColor(color, alpha)
  return rgbm(color.r, color.g, color.b, alpha)
end

local function hudLabel(ctx, text, x1, y1, x2, y2, color, size, align, bold)
  if bold then ui.pushDWriteFont('@System;Weight=Bold;Stretch=Condensed') end
  ui.dwriteDrawTextClipped(text, math.max(8, (size or 13) * ctx.scale),
    hudPoint(ctx, x1, y1), hudPoint(ctx, x2, y2),
    align or ui.Alignment.Center, ui.Alignment.Center, false, color or COLOR_TEXT)
  if bold then ui.popDWriteFont() end
end

local function hudPanel(ctx, x1, y1, x2, y2, accent, fillAlpha, rounding)
  local p1, p2 = hudPoint(ctx, x1, y1), hudPoint(ctx, x2, y2)
  ui.drawRectFilled(p1, p2, rgbm(0.035, 0.038, 0.045,
    (fillAlpha or 0.88) * settings.hudOpacity), (rounding or 7) * ctx.scale)
  ui.drawRect(p1, p2, hudColor(accent, 0.48),
    (rounding or 7) * ctx.scale, 0, math.max(1, ctx.scale))
end

local function hudProgress(ctx, x1, y1, x2, y2, value, color, label)
  value = saturate(value)
  local p1, p2 = hudPoint(ctx, x1, y1), hudPoint(ctx, x2, y2)
  ui.drawRectFilled(p1, p2, rgbm(0.005, 0.006, 0.008,
    0.90 * settings.hudOpacity), 5 * ctx.scale)
  if value > 0.002 then
    local fillP2 = vec2(p1.x + (p2.x - p1.x) * value, p2.y)
    ui.drawRectFilledMultiColor(p1, fillP2,
      hudColor(color, 0.55), color, color, hudColor(color, 0.55))
  end
  ui.drawRect(p1, p2, hudColor(color, 0.58), 5 * ctx.scale,
    0, math.max(1, ctx.scale))
  if label then hudLabel(ctx, label, x1 + 5, y1, x2 - 5, y2, COLOR_TEXT, 12) end
end

local function drawHudWheel(ctx, x, y, radius, accent)
  local center = hudPoint(ctx, x, y)
  local r = radius * ctx.scale
  local steer = clamp(telemetry.steer, -1, 1)
  local angle = steer * 2.20
  local rim = math.abs(steer) > 0.02 and accent or COLOR_MUTED
  ui.drawCircleFilled(center, r + 4 * ctx.scale,
    rgbm(0.004, 0.005, 0.007, 0.96 * settings.hudOpacity), 48)
  ui.drawCircle(center, r, rim, 48, math.max(2, 5 * ctx.scale))
  ui.drawCircle(center, r - 7 * ctx.scale, hudColor(accent, 0.25), 48,
    math.max(1, ctx.scale))
  for _, offset in ipairs({ 0, 2.22, -2.22 }) do
    local a = angle + offset
    local direction = vec2(math.cos(a), math.sin(a))
    ui.drawLine(center, center + direction * (r - 8 * ctx.scale), rim,
      math.max(1, 3 * ctx.scale))
  end
  local marker = center + vec2(math.cos(angle - math.pi / 2),
    math.sin(angle - math.pi / 2)) * r
  ui.drawCircleFilled(marker, math.max(2, 3.5 * ctx.scale), accent, 16)
  ui.drawCircleFilled(center, 9 * ctx.scale,
    rgbm(0.008, 0.009, 0.012, 1), 24)
  ui.drawCircle(center, 9 * ctx.scale, rim, 24, math.max(1, 2 * ctx.scale))
  local direction = steer < -0.02 and 'LEFT' or (steer > 0.02 and 'RIGHT' or 'CENTRE')
  hudLabel(ctx, direction, x - radius, y + radius + 6,
    x + radius, y + radius + 25, rim, 11, ui.Alignment.Center, true)
end

local function pedalPath(center, axisX, axisY, halfWidth, halfHeight, color, outline, thickness)
  ui.pathLineTo(center - axisX * halfWidth - axisY * halfHeight)
  ui.pathLineTo(center + axisX * halfWidth - axisY * halfHeight)
  ui.pathLineTo(center + axisX * (halfWidth + 2) + axisY * halfHeight)
  ui.pathLineTo(center - axisX * (halfWidth + 2) + axisY * halfHeight)
  if outline then ui.pathStroke(color, true, thickness or 1)
  else ui.pathFillConvex(color) end
end

local function drawHudPedal(ctx, x, label, value, color, targetValue)
  value = saturate(value)
  local s = ctx.scale
  local hinge = hudPoint(ctx, x, 128)
  local center = hudPoint(ctx, x + value * 4, 193 + value * 9)
  local angle = -0.10 + value * 0.20
  local axisX = vec2(math.cos(angle), math.sin(angle))
  local axisY = vec2(-math.sin(angle), math.cos(angle))
  local halfWidth, halfHeight = 14 * s, 22 * s
  hudLabel(ctx, label, x - 34, 105, x + 34, 124, COLOR_MUTED, 11,
    ui.Alignment.Center, true)
  if targetValue ~= nil then
    local target = saturate(targetValue)
    local targetCenter = hudPoint(ctx, x + target * 4, 193 + target * 9)
    local targetAngle = -0.10 + target * 0.20
    local tx = vec2(math.cos(targetAngle), math.sin(targetAngle))
    local ty = vec2(-math.sin(targetAngle), math.cos(targetAngle))
    pedalPath(targetCenter, tx, ty, halfWidth + 3 * s, halfHeight + 3 * s,
      hudColor(accentColor(), 0.48), true, math.max(1, s))
  end
  local armEnd = center - axisY * (halfHeight - 2 * s)
  ui.drawLine(hinge, armEnd, rgbm(0.58, 0.60, 0.64, 1), math.max(2, 5 * s))
  ui.drawLine(hinge, armEnd, rgbm(0.012, 0.014, 0.018, 1), math.max(1, 2 * s))
  ui.drawCircleFilled(hinge, 5 * s, rgbm(0.008, 0.009, 0.012, 1), 20)
  ui.drawCircle(hinge, 5 * s, color, 20, math.max(1, 1.5 * s))
  pedalPath(center, axisX, axisY, halfWidth, halfHeight,
    rgbm(0.012, 0.014, 0.018, 1), false)
  if value > 0.002 then
    local fillHalf = math.max(s, (halfHeight - 3 * s) * value)
    local bottom = center + axisY * (halfHeight - 3 * s)
    local fillCenter = bottom - axisY * fillHalf
    pedalPath(fillCenter, axisX, axisY, halfWidth - 3 * s, fillHalf,
      hudColor(color, 0.90), false)
  end
  pedalPath(center, axisX, axisY, halfWidth, halfHeight,
    value > 0.01 and color or COLOR_MUTED, true, math.max(1, 1.5 * s))
  for rib = -1, 1 do
    local ribCenter = center + axisY * (rib * 8 * s)
    ui.drawLine(ribCenter - axisX * (9 * s), ribCenter + axisX * (9 * s),
      value > 0.01 and color or COLOR_MUTED, math.max(1, s))
  end
  hudLabel(ctx, string.format('%.0f%%', value * 100), x - 30, 229,
    x + 30, 248, value > 0.01 and color or COLOR_MUTED, 12,
    ui.Alignment.Center, true)
end

local function drawHudBackground(ctx, accent)
  local opacity = settings.hudOpacity
  ui.setCursor(vec2(0, 0))
  ui.dummy(vec2(1, 1))
  ui.drawRectFilledMultiColor(vec2(0, 0), ctx.size,
    rgbm(accent.r * 0.08, accent.g * 0.08, accent.b * 0.08, opacity),
    rgbm(0.018, 0.020, 0.026, opacity),
    rgbm(0.003, 0.004, 0.006, opacity),
    rgbm(0.003, 0.004, 0.006, opacity))
  ui.drawRectFilled(hudPoint(ctx, 0, 0), hudPoint(ctx, 720, 4), accent)
end

local function drawHudHeader(ctx, accent, stateText, stateColor)
  hudPanel(ctx, 12, 27, 708, 70, accent, 0.70, 8)
  ui.pushDWriteFont('@System;Weight=Black;Stretch=Condensed')
  ui.dwriteDrawTextClipped('CPC DRIVE SUITE', 22 * ctx.scale,
    hudPoint(ctx, 23, 29), hudPoint(ctx, 520, 53),
    ui.Alignment.Start, ui.Alignment.Center, false, COLOR_TEXT)
  ui.popDWriteFont()
  hudLabel(ctx, 'WHEEL INPUT  /  CAMERA MOTION  /  NECKFX', 24, 52, 520, 68,
    COLOR_MUTED, 10, ui.Alignment.Start)
  local pulseStrength = clamp(settings.hudAnimation, 0, 1.5)
  local pulse = 1
  if clutchStatusKind == 'action' and pulseStrength > 0 then
    pulse = 0.82 + 0.18 * math.sin(elapsedTime * (8 + 6 * pulseStrength)) *
      math.min(pulseStrength, 1)
  end
  local p1, p2 = hudPoint(ctx, 566, 37), hudPoint(ctx, 696, 62)
  ui.drawRectFilled(p1, p2,
    hudColor(stateColor, (0.13 + 0.05 * pulse) * settings.hudOpacity), 11 * ctx.scale)
  ui.drawRect(p1, p2, stateColor, 11 * ctx.scale, 0, math.max(1, ctx.scale))
  hudLabel(ctx, stateText, 566, 37, 696, 62, stateColor, 11,
    ui.Alignment.Center, true)
end

local function drawHudRPM(ctx, accent, y1, y2)
  if not settings.hudShowRPM then return end
  local fraction = saturate((telemetry.rpm - telemetry.idleRPM) /
    math.max(telemetry.limiterRPM - telemetry.idleRPM, 1))
  local color = fraction > 0.88 and COLOR_WARNING
    or (fraction > 0.68 and COLOR_ACTION or accent)
  hudProgress(ctx, 16, y1, 704, y2, fraction, color,
    string.format('RPM %.0f / %.0f     %+.0f per sec',
      telemetry.rpm, telemetry.limiterRPM, rpmTrend))
end

local function hudState()
  if not settings.suiteEnabled then return 'PAUSED', COLOR_WARNING end
  if clutchStatusKind == 'warning' then return 'CHECK', COLOR_WARNING end
  if clutchStatusKind == 'action' then return 'ACTING', COLOR_ACTION end
  return 'ACTIVE', COLOR_ACTIVE
end

local function displaySpeed()
  if settings.hudSpeedMph then return telemetry.speed * 0.621371, 'mph' end
  return telemetry.speed, 'km/h'
end

local function drawFullHud(ctx, accent, inputsOnly)
  local stateText, stateColor = hudState()
  drawHudBackground(ctx, accent)
  drawHudHeader(ctx, accent, stateText, stateColor)
  drawHudRPM(ctx, accent, 78, 96)

  if settings.hudShowWheel then
    hudLabel(ctx, 'STEERING', 20, 103, 126, 122, COLOR_MUTED, 10,
      ui.Alignment.Center, true)
    drawHudWheel(ctx, 73, 170, 42, accent)
  end

  if settings.hudShowPedals then
    local effectiveClutch = math.min(telemetry.rawClutch, clutchCommand)
    drawHudPedal(ctx, 166, 'THROTTLE', telemetry.gas, COLOR_WARNING)
    drawHudPedal(ctx, 232, 'BRAKE', telemetry.brake, COLOR_WARNING)
    drawHudPedal(ctx, 298, 'CLUTCH', 1 - effectiveClutch, COLOR_TEXT,
      1 - clutchTarget)
  end

  local gearX1 = inputsOnly and 375 or 356
  local gearX2 = inputsOnly and 485 or 442
  hudPanel(ctx, gearX1, 106, gearX2, 249, accent, 0.90, 8)
  hudLabel(ctx, 'GEAR', gearX1, 111, gearX2, 132, COLOR_MUTED, 11,
    ui.Alignment.Center, true)
  local gear = telemetry.gear == 0 and 'N'
    or (telemetry.gear == -1 and 'R' or tostring(telemetry.gear))
  hudLabel(ctx, gear, gearX1, 128, gearX2, 231, COLOR_TEXT, 61,
    ui.Alignment.Center, true)

  local speed, speedUnit = displaySpeed()
  local speedX1 = gearX2 + 10
  local speedX2 = inputsOnly and 704 or 566
  hudPanel(ctx, speedX1, 106, speedX2, 249, accent, 0.90, 8)
  hudLabel(ctx, 'ROAD SPEED', speedX1, 111, speedX2, 132, COLOR_MUTED, 10,
    ui.Alignment.Center, true)
  hudLabel(ctx, string.format('%.0f', speed), speedX1, 132, speedX2, 213,
    COLOR_TEXT, 42, ui.Alignment.Center, true)
  hudLabel(ctx, speedUnit, speedX1, 210, speedX2, 237, COLOR_MUTED, 12,
    ui.Alignment.Center, true)

  if not inputsOnly and settings.hudShowCamera then
    hudPanel(ctx, 576, 106, 704, 249, accent, 0.90, 8)
    hudLabel(ctx, 'CAMERA', 576, 111, 704, 132, COLOR_MUTED, 10,
      ui.Alignment.Center, true)
    hudLabel(ctx, string.format('FOV  %.1f°', renderedFov), 584, 137, 696, 160,
      COLOR_TEXT, 14, ui.Alignment.Start, true)
    hudLabel(ctx, string.format('THR  %3.0f%%', throttleEffectScale * 100),
      584, 163, 696, 184, accent, 12, ui.Alignment.Start)
    hudLabel(ctx, string.format('NECK %3.0f%%', neckTelemetry.effectStrength * 100),
      584, 187, 696, 208, neckIsOnline() and COLOR_ACTIVE or COLOR_WARNING,
      12, ui.Alignment.Start)
    hudLabel(ctx, neckIsOnline() and '6DOF ONLINE' or '6DOF OFFLINE',
      584, 216, 696, 239, neckIsOnline() and COLOR_ACTIVE or COLOR_WARNING,
      10, ui.Alignment.Center, true)
  end

  if settings.hudShowCamera and not inputsOnly then
    hudPanel(ctx, 16, 263, 704, 340, accent, 0.76, 8)
    hudLabel(ctx, 'THROTTLE CAMERA', 27, 271, 165, 289, accent, 10,
      ui.Alignment.Start, true)
    hudLabel(ctx, string.format('XYZ  %+.1f / %+.1f / %+.1f mm',
      outputLateral * 1000, outputVertical * 1000, outputForward * 1000),
      170, 269, 425, 291, COLOR_TEXT, 11, ui.Alignment.Start)
    hudLabel(ctx, string.format('P/Y  %+.2f / %+.2f°', outputPitch, outputYaw),
      430, 269, 690, 291, COLOR_TEXT, 11, ui.Alignment.Start)
    hudLabel(ctx, 'NECKFX 6DOF', 27, 307, 165, 327,
      neckIsOnline() and COLOR_ACTIVE or COLOR_WARNING, 10,
      ui.Alignment.Start, true)
    hudLabel(ctx, string.format('XYZ  %+.1f / %+.1f / %+.1f mm',
      neckTelemetry.outputX * 1000, neckTelemetry.outputY * 1000,
      neckTelemetry.outputZ * 1000), 170, 305, 425, 329,
      COLOR_TEXT, 11, ui.Alignment.Start)
    hudLabel(ctx, string.format('Y/P/R  %+.2f / %+.2f / %+.2f°',
      neckTelemetry.outputYaw, neckTelemetry.outputPitch, neckTelemetry.outputRoll),
      430, 305, 690, 329, COLOR_TEXT, 11, ui.Alignment.Start)
  end

  if settings.hudShowStatus then
    local statusY1 = inputsOnly and 270 or 351
    local statusY2 = inputsOnly and 326 or 389
    local color = clutchStateColor()
    local alpha = 0.10 + actionFlash * 0.17 * settings.hudAnimation
    local p1, p2 = hudPoint(ctx, 16, statusY1), hudPoint(ctx, 704, statusY2)
    ui.drawRectFilled(p1, p2, hudColor(color, alpha), 7 * ctx.scale)
    ui.drawRect(p1, p2, color, 7 * ctx.scale, 0, math.max(1, ctx.scale))
    hudLabel(ctx, clutchStatus, 28, statusY1 + 2, 490, statusY2 - 2,
      color, 13, ui.Alignment.Start, true)
    local effectiveClutch = math.min(telemetry.rawClutch, clutchCommand)
    hudLabel(ctx, string.format('CLUTCH  %.0f%% PRESSED', (1 - effectiveClutch) * 100),
      500, statusY1 + 2, 692, statusY2 - 2, accent, 11,
      ui.Alignment.Center, true)
  end
end

local function drawMinimalHud(ctx, accent)
  local stateText, stateColor = hudState()
  drawHudBackground(ctx, accent)
  drawHudHeader(ctx, accent, stateText, stateColor)
  drawHudRPM(ctx, accent, 78, 98)
  local gear = telemetry.gear == 0 and 'N'
    or (telemetry.gear == -1 and 'R' or tostring(telemetry.gear))
  hudPanel(ctx, 16, 109, 126, 175, accent, 0.90, 7)
  hudLabel(ctx, gear, 16, 109, 126, 175, COLOR_TEXT, 43,
    ui.Alignment.Center, true)
  local speed, unit = displaySpeed()
  hudPanel(ctx, 136, 109, 320, 175, accent, 0.90, 7)
  hudLabel(ctx, string.format('%.0f  %s', speed, unit), 136, 109, 320, 175,
    COLOR_TEXT, 25, ui.Alignment.Center, true)
  local effectiveClutch = math.min(telemetry.rawClutch, clutchCommand)
  hudProgress(ctx, 330, 109, 704, 140, 1 - effectiveClutch, accent,
    string.format('CLUTCH %.0f%% PRESSED', (1 - effectiveClutch) * 100))
  hudLabel(ctx, clutchStatus, 339, 143, 695, 175, clutchStateColor(), 12,
    ui.Alignment.Center, true)
  if settings.hudShowStatus then
    local color = clutchStateColor()
    local p1, p2 = hudPoint(ctx, 16, 186), hudPoint(ctx, 704, 224)
    ui.drawRectFilled(p1, p2, hudColor(color, 0.10 + actionFlash * 0.17),
      7 * ctx.scale)
    ui.drawRect(p1, p2, color, 7 * ctx.scale, 0, math.max(1, ctx.scale))
    hudLabel(ctx, string.format('GAS %.0f%%   BRAKE %.0f%%   WHEEL %+.0f%%',
      telemetry.gas * 100, telemetry.brake * 100, telemetry.steer * 100),
      28, 187, 408, 223, COLOR_TEXT, 12, ui.Alignment.Start, true)
    hudLabel(ctx, string.format('FOV %.1f°   NECK %.0f%%',
      renderedFov, neckTelemetry.effectStrength * 100),
      420, 187, 692, 223, accent, 12, ui.Alignment.Center, true)
  end
end

function script.windowHUD(dt)
  local accent = accentColor()
  if settings.hudMode == 3 then
    drawMinimalHud(hudContext(238), accent)
  elseif settings.hudMode == 2 then
    drawFullHud(hudContext(340), accent, true)
  else
    drawFullHud(hudContext(400), accent, false)
  end
end
