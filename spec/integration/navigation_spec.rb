require 'spec_helper'

describe "Navigation" do
  it "should be a valid app" do
    if defined?(Rails)
      ::Rails.application.should be_a(Dummy::Application)
    end
  end
end
