class MainLayout < MotionKit::Layout

  VERTICAL_SPACE_BETWEEN_ITEMS          = 25
  VERTICAL_SPACE_BETWEEN_RELATED_ITEMS  = 15
  RIGHT_ALIGN_AT                        = 150
  SPACE_BETWEEN_LABEL_CONTROL           = 10
  MARGIN_LEFT                           = 25
  MARGIN_RIGHT                          = 25
  MARGIN_TOP                            = 50
  MARGIN_BOTTOM                         = 25
  TEXT_INSET                            = 10

  #------------------------------------------------------------------------------
  def layout
    root NSView, :root do
      add NSButton,     :watch_folder
      add NSTextField,  :folder_path

      add NSScrollView, :scroll_view do
        self.documentView = add NSTextView, :log_field
      end
    end
  end
  
  # Auto constraints don't work for the root view when you're animating the
  # the display of the view.  So use autoresizingMask for root view
  #------------------------------------------------------------------------------
  def root_style
    self.translatesAutoresizingMaskIntoConstraints = true
    self.autoresizingMask       = NSViewWidthSizable | NSViewHeightSizable
    self.wantsLayer             = true
  end

  #------------------------------------------------------------------------------
  def watch_folder_style
    self.bezelStyle   = NSRoundedBezelStyle
    self.alignment    = NSCenterTextAlignment
    self.title        = 'Watch Folder'
    constraints do
      top.equals(view).plus(MARGIN_TOP)
      left.equals(view).plus(MARGIN_LEFT)
    end
  end

  #------------------------------------------------------------------------------
  def folder_path_style
    self.stringValue      = 'Choose a folder to watch...'
    self.font             = NSFont.systemFontOfSize(0)
    self.alignment        = NSLeftTextAlignment
    self.editable         = false
    self.selectable       = false
    self.bezeled          = false
    self.drawsBackground  = false
    constraints do
      top.equals(view).plus(MARGIN_TOP)
      left.equals(:watch_folder, :right).plus(SPACE_BETWEEN_LABEL_CONTROL)
      right.equals(view).minus(MARGIN_LEFT)
    end
  end

  #------------------------------------------------------------------------------
  def scroll_view_style
    self.hasVerticalScroller    = true
    self.hasHorizontalScroller  = false
    self.autohidesScrollers     = true
    constraints do
      top.equals(:watch_folder, :bottom).plus(VERTICAL_SPACE_BETWEEN_ITEMS)
      left.equals(view).plus(MARGIN_LEFT)
      right.equals(view).minus(MARGIN_RIGHT)
      bottom.equals(view).minus(MARGIN_BOTTOM)
    end
  end

  #------------------------------------------------------------------------------
  def log_field_style
    self.translatesAutoresizingMaskIntoConstraints = true
    self.autoresizingMask         = NSViewWidthSizable | NSViewHeightSizable
    self.editable                 = true
    self.allowsUndo               = true
    self.richText                 = true
    self.importsGraphics          = false
    self.allowsImageEditing       = false
    self.automaticLinkDetectionEnabled      = false
    self.automaticQuoteSubstitutionEnabled  = false
    self.automaticDashSubstitutionEnabled   = false
    self.usesInspectorBar         = false
    self.usesFontPanel            = false # TODO make sure font panel menu item is removed altogether
    self.usesFindBar              = false  # TODO implement find bar

    # sets the left/right indent.  This is better than the textContainerInset
    # because in this case the indent responds to the mouse drags
    self.textContainer.lineFragmentPadding = 10

    self.textContainerInset       = [0, TEXT_INSET]
    self.enabledTextCheckingTypes = NSTextCheckingAllCustomTypes | NSTextCheckingTypeDate #NSTextCheckingTypeDash
    self.font                     = NSFont.fontWithName('Source Code Pro', size: 13) || NSFont.userFixedPitchFontOfSize(13)
  end

end
