# frozen_string_literal: true

describe "Application 'fsevents-tester'" do
  before do
    @app = NSApplication.sharedApplication
  end

  it 'has one window' do
    @app.windows.size.should == 1
  end
end
