# Uses the CDEvents library to encapsulate FSEvents
# https://github.com/rastersize/CDEvents
#------------------------------------------------------------------------------
class FSEvents
  attr_accessor :events
  
  NOTIFICATION_LATENCY              = 3.0 # NSTimeInterval
  SHOULD_IGNORE_EVENT_FROM_SUB_DIRS = false

  FLAG_METHODS = [:isGenericChange, :isCreated, :isRemoved, :isFile, :isDir, :isSymlink, :isRenamed,
                  :isModified, :mustRescanSubDirectories, :isUserDropped, :isKernelDropped, 
                  :isEventIdentifiersWrapped, :isHistoryDone, :isRootChanged, :isRootChanged,
                  :didVolumeMount, :didVolumeUnmount, :isInodeMetadataModified, :isFinderInfoModified,
                  :didChangeOwner, :isXattrModified].freeze

  #------------------------------------------------------------------------------
  def watch(watch_url, options = {})
    @events =  CDEvents.alloc.initWithURLs([watch_url],
                  block:lambda do |watcher_ptr, event_ptr|
                    self.log_event(watcher_ptr, event_ptr)
                  end,
                  onRunLoop: NSRunLoop.currentRunLoop,
                  sinceEventIdentifier: KCDEventsSinceEventNow,
                  notificationLantency: NOTIFICATION_LATENCY,
                  ignoreEventsFromSubDirs: SHOULD_IGNORE_EVENT_FROM_SUB_DIRS,
                  excludeURLs:nil,
                  streamCreationFlags: (KFSEventStreamCreateFlagUseCFTypes | KFSEventStreamCreateFlagWatchRoot | KFSEventStreamCreateFlagFileEvents)
                )

    @text_field = options[:text_field]
  end

  #------------------------------------------------------------------------------
  def log_event(watcher_ptr, event_ptr)
    msg  = "FSEvent : path:  #{event_ptr.URL.path}\n"
    msg << "        : flags: #{event_ptr.flags} (#{flags_to_s(event_ptr)})\n\n"
    if @text_field
      @text_field.setSelectedRange(NSMakeRange(@text_field.string.length, 0))
      @text_field.insertText(msg)
      @text_field.setSelectedRange(NSMakeRange(@text_field.string.length, 0))
      puts(msg)
    else
      NSLog msg
    end
  end

  #------------------------------------------------------------------------------
  def flags_to_s(event)
    flags_set = []
    FLAG_METHODS.each {|meth| flags_set << meth if event.send(meth)}
    flags_set.join(', ')
  end
end
