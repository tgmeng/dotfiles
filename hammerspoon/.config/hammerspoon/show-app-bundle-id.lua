local ShowAppBundleId = {}

function ShowAppBundleId:new()
  local obj = {
    appWatcher = nil,
    logger = hs.logger.new('show-app-bundle-id', 'info')
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function ShowAppBundleId:start()
  self:stop()
  self.appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
      if appObject then
        self.logger:i(appObject:bundleID())
      end
    end
  end)
  self.appWatcher:start()
end

function ShowAppBundleId:stop()
  if self.appWatcher then
    self.appWatcher:stop()
    self.appWatcher = nil
  end
end

return ShowAppBundleId
