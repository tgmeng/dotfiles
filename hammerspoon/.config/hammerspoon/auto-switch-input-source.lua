local AutoSwitchInputSource = {};

function AutoSwitchInputSource:new(config)
  local obj = {
    appWatcher = nil,
    config = config,
    logger = hs.logger.new('auto-switch-input-source', 'info')
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function AutoSwitchInputSource:tryToSwitchInputSourceByFrontMost()
  local app = hs.window.frontmostWindow():application()

  if app == nil then
    return
  end

  local sourceId = self.config[app:bundleID()]
  if sourceId then
    local currentSourceId = hs.keycodes.currentSourceID()
    if not (currentSourceId == sourceId) then
      hs.keycodes.currentSourceID(sourceId)
    end
  end
end

function AutoSwitchInputSource:start()
  self:stop();
  self.appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
      -- self.logger:i(hs.keycodes.currentSourceID())
      self:tryToSwitchInputSourceByFrontMost()
    end
  end)
  self.appWatcher:start()
end

function AutoSwitchInputSource:stop()
  if self.appWatcher then
    self.appWatcher:stop()
    self.appWatcher = nil
  end
end

return AutoSwitchInputSource;
