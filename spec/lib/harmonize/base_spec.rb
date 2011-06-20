require 'spec_helper'

describe Harmonize::Base do
  before(:all) do
    @set1 = [
      { :name => 'One', :cost_cents => 100 },
      { :name => 'Two', :cost_cents => 200 },
    ]
    @set2 = [
      { :name => 'Three', :cost_cents => 300 },
      { :name => 'Four',  :cost_cents => 400 },
    ]
  end
  context "no options given" do
    context "harmonize! not implemented" do
      it "should raise NotImplemented" do
        expect { Widget.harmonize! }.to raise_error(NotImplementedError)
      end
    end
  end
end
