-- ---- 小ユーティリティ：安全に Spoons を読む
local function safeLoadSpoon(name)
  local ok = pcall(function() hs.loadSpoon(name) end)
  if not ok then
    hs.printf("Unable to load Spoon: %s", name)
    return false
  end
  return spoon[name] ~= nil
end

-- ---- ShiftIt（これだけ先に確実に動かす）
if safeLoadSpoon("ShiftIt") then
  local mash = {"ctrl", "alt", "cmd"}
  spoon.ShiftIt:bindHotkeys({
    left        = {mash, "Left"},
    right       = {mash, "Right"},
    up          = {mash, "Up"},
    down        = {mash, "Down"},
    maximum     = {mash, "M"},
    center      = {mash, "C"},
    tl          = {mash, "1"},
    tr          = {mash, "2"},
    bl          = {mash, "J"},
    br          = {mash, "4"},
    thirdLeft      = {mash, "D"},
    thirdRight     = {mash, "F"},
    twoThirdsLeft  = {mash, "E"},
    twoThirdsRight = {mash, "R"},
  })
else
  hs.notify.new({title="Hammerspoon", informativeText="ShiftIt not found. Put ShiftIt.spoon under ~/.hammerspoon/Spoons"}):send()
end

-- ---- 起動通知
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()
