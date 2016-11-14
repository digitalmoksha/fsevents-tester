class AppDelegate
  #------------------------------------------------------------------------------
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    # start_fsevents
  end

  #------------------------------------------------------------------------------
  def buildWindow
    @window_controller = WindowController.alloc.init
    @window_controller.showWindow(self)
    @window_controller.window.orderFrontRegardless
  end

  # Find the Documents directory in the user's home directory, return an NSURL
  #------------------------------------------------------------------------------
  def documents_directory
    NSFileManager.defaultManager.URLsForDirectory(NSDocumentDirectory, inDomains: NSUserDomainMask).first
  end
end
