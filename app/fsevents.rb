# frozen_string_literal: true

# Uses the CDEvents library to encapsulate FSEvents
# https://github.com/rastersize/CDEvents
#------------------------------------------------------------------------------
class FSEvents
  attr_accessor :watcher, :delegate, :enabled

  NOTIFICATION_LATENCY              = 3.0 # NSTimeInterval
  SHOULD_IGNORE_EVENT_FROM_SUB_DIRS = false

  FLAG_METHODS = [:isGenericChange, :isCreated, :isRemoved, :isFile, :isDir, :isSymlink, :isRenamed,
                  :isModified, :mustRescanSubDirectories, :isUserDropped, :isKernelDropped, 
                  :isEventIdentifiersWrapped, :isHistoryDone, :isRootChanged, :isRootChanged,
                  :didVolumeMount, :didVolumeUnmount, :isInodeMetadataModified, :isFinderInfoModified,
                  :didChangeOwner, :isXattrModified].freeze

  #------------------------------------------------------------------------------
  def initialize(_opts = {})
    @watcher = nil
    @enabled = false
  end

  #------------------------------------------------------------------------------
  def watch(watch_url, options = {})
    create_flags = (KFSEventStreamCreateFlagUseCFTypes | KFSEventStreamCreateFlagWatchRoot |
                      KFSEventStreamCreateFlagFileEvents | KFSEventStreamCreateFlagMarkSelf)
    @delegate = options[:delegate]
    @watcher&.unwatch
    @enabled  = true
    @watcher  = CDEvents.alloc.initWithURLs([watch_url],
                                            block: lambda do |watcher_ptr, event_ptr|
                                              handle_event(watcher_ptr, event_ptr)
                                            end,
                                            onRunLoop: NSRunLoop.currentRunLoop,
                                            sinceEventIdentifier: KCDEventsSinceEventNow,
                                            notificationLantency: NOTIFICATION_LATENCY,
                                            ignoreEventsFromSubDirs: SHOULD_IGNORE_EVENT_FROM_SUB_DIRS,
                                            excludeURLs: nil,
                                            streamCreationFlags: create_flags)

    @text_field = options[:text_field]
  end

  #------------------------------------------------------------------------------
  def handle_event(_watcher_ptr, event_ptr)
    msg  = "FSEvent :     path: #{event_ptr.URL.path}\n"
    msg << "        : file ref: #{event_ptr.URL.fileReferenceURL}\n"
    msg << "        : ref path: #{event_ptr.URL.fileReferenceURL ? event_ptr.URL.fileReferenceURL.path : ''}\n"
    msg << "        :    flags: #{event_ptr.flags} (#{flags_to_s(event_ptr)})\n\n"
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
    FLAG_METHODS.each { |meth| flags_set << meth if event.send(meth) }
    flags_set << 'isOwnEvent' if isOwnEvent(event)
    flags_set.join(', ')
  end

  #------------------------------------------------------------------------------
  def isOwnEvent(event)
    (event.flags & KFSEventStreamEventFlagOwnEvent) != 0
  end

  # While garbage collection should properly deallocate the CDEvents object and
  # stop events, we need a way to stop them immediately.  Can't call `dealloc`,
  # so set watcher to nil
  #------------------------------------------------------------------------------
  def unwatch
    if @watcher
      @watcher = nil
      @enabled = false
    end
  end
end
