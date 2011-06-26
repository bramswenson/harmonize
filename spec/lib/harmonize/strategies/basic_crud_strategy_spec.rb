require 'spec_helper'

describe Harmonize::Strategies::BasicCrudStrategy do

  describe ".harmonize!" do

    before(:each) do
      Widget.remove_harmonizer!
      class Widget
        harmonize do |config|
          config.key = :name
          config.source = lambda do
            [ { :name => 'widget1', :cost_cents => 100 } ]
          end
        end
      end
    end

    describe Harmonize::Log do

      it "should create 1" do
        expect { Widget.harmonize_default! }.to change(Harmonize::Log, :count).by(1)
      end

    end

    describe Harmonize::Modification do

      it "should create 1" do
        expect { Widget.harmonize_default! }.to change(Harmonize::Modification, :count).by(1)
      end

    end

    describe Widget do

      it "should create 1" do
        expect { Widget.harmonize_default! }.to change(Widget, :count).by(1)
      end

    end

  end
end

