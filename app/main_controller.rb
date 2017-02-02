class MainController < NSViewController

  #------------------------------------------------------------------------------
  def loadView
    @layout   = MainLayout.new
    self.view = @layout.view

    @speech = NSSpeechSynthesizer.alloc.initWithVoice(nil)
    @speech.delegate = self

    @watch_button = @layout.get(:watch_folder)
    @watch_button.setTarget(self)
    @watch_button.setAction(:'watch_folder:')

    @folder_path  = @layout.get(:folder_path)
    @log_field    = @layout.get(:log_field)

    @fsevents = FSEvents.new
  end

  #------------------------------------------------------------------------------
  def watch_folder(sender)
    url = choose_watch_folder
    if url
      @folder_path.stringValue = url.path
      @fsevents.watch(url, text_field: @log_field)
      @log_field.setSelectedRange(NSMakeRange(@log_field.string.length, 0))
      @log_field.insertText("\n\nWatching: #{@fsevents.watcher.watchedURLs[0].path}\n")
      @log_field.insertText("------------------------------------------------------------------------------\n")
      @log_field.setSelectedRange(NSMakeRange(@log_field.string.length, 0))
    end
  end

  # open panel to allow them to choose a folder to add as a source
  #------------------------------------------------------------------------------
  def choose_watch_folder(prompt = 'Watch', message = nil)
    panel = NSOpenPanel.openPanel
    panel.canChooseDirectories  = true
    panel.canChooseFiles        = false
    panel.prompt                = prompt
    panel.message               = message if message

    result = panel.runModal
    return result == NSFileHandlingPanelOKButton ? panel.URLs[0] : nil
  end

end