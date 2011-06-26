require 'spec_helper'

describe Harmonize::Strategies::BasicCrudStrategy do

  describe ".harmonize!" do

    context "harmonization with creates" do
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
        before(:each) do
          @log = Widget.harmonize_default!
        end

        it "should create 1" do
          @log.should be_a(Harmonize::Log)
        end

        it "should have 1 created" do
          @log.created.count.should == 1
        end

        it "should have 0 updated" do
          @log.updated.count.should == 0
        end

        it "should have 0 destroyed" do
          @log.destroyed.count.should == 0
        end

        it "should have 0 errored" do
          @log.errored.count.should == 0
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

    context "harmonization updates" do
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
        Widget.harmonize_default!
        Widget.remove_harmonizer!
        class Widget
          harmonize do |config|
            config.key = :name
            config.source = lambda do
              [ { :name => 'widget1', :cost_cents => 200 } ]
            end
          end
        end
      end

      describe Harmonize::Log do
        before(:each) do
          @log = Widget.harmonize_default!
        end

        it "should create 1" do
          @log.should be_a(Harmonize::Log)
        end

        it "should have 0 created" do
          @log.created.count.should == 0
        end

        it "should have 1 updated" do
          @log.updated.count.should == 1
        end

        it "should have 0 destroyed" do
          @log.destroyed.count.should == 0
        end

        it "should have 0 errored" do
          @log.errored.count.should == 0
        end

      end

      describe Harmonize::Modification do

        it "should create 1" do
          expect { Widget.harmonize_default! }.to change(Harmonize::Modification, :count).by(1)
        end

      end

      describe Widget do

        it "should update 1" do
          Widget.harmonize_default!
          Widget.last.cost_cents.should == 200
        end

      end

    end

    context "harmonization deletes" do
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
        Widget.harmonize_default!
        Widget.remove_harmonizer!
        class Widget
          harmonize do |config|
            config.key = :name
            config.source = lambda do
              [ ]
            end
          end
        end
      end

      describe Harmonize::Log do
        before(:each) do
          @log = Widget.harmonize_default!
        end

        it "should create 1" do
          @log.should be_a(Harmonize::Log)
        end

        it "should have 0 created" do
          @log.created.count.should == 0
        end

        it "should have 0 updated" do
          @log.updated.count.should == 0
        end

        it "should have 1 destroyed" do
          @log.destroyed.count.should == 1
        end

        it "should have 0 errored" do
          @log.errored.count.should == 0
        end

      end

      describe Harmonize::Modification do

        it "should create 1" do
          expect { Widget.harmonize_default! }.to change(Harmonize::Modification, :count).by(1)
        end

      end

      describe Widget do

        it "should destroy 1" do
          expect { Widget.harmonize_default! }.to change(Widget, :count).by(-1)
        end

      end

    end

    context "harmonization errors" do
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
        Widget.harmonize_default!
        Widget.remove_harmonizer!
        class Widget
          harmonize do |config|
            config.key = :name
            config.source = lambda do
              [ { :name => 'widget1', :cost_cents => 100, :invalid_attribute => 'itis' } ]
            end
          end
        end
      end

      describe Harmonize::Log do
        before(:each) do
          @log = Widget.harmonize_default!
        end

        it "should create 1" do
          @log.should be_a(Harmonize::Log)
        end

        it "should have 0 created" do
          @log.created.count.should == 0
        end

        it "should have 0 updated" do
          @log.updated.count.should == 0
        end

        it "should have 0 destroyed" do
          @log.destroyed.count.should == 0
        end

        it "should have 1 errored" do
          @log.errored.count.should == 1
        end

      end

      describe Harmonize::Modification do

        it "should create 1" do
          expect { Widget.harmonize_default! }.to change(Harmonize::Modification, :count).by(1)
        end

        it "should have the error messages" do
          @log = Widget.harmonize_default!
          @log.errored.first.instance_errors.should == 'unknown attribute: invalid_attribute'
        end

      end

      describe Widget do

        it "should not be destroyed when errored" do
          expect { Widget.harmonize_default! }.to change(Widget, :count).by(0)
        end

      end

    end

    context "harmonization with a bit of everything" do
      before(:each) do
        Widget.remove_harmonizer!
        class Widget
          harmonize do |config|
            config.key = :name
            config.source = lambda do
              [ { :name => 'widget1', :cost_cents => 100 },
                { :name => 'widget2', :cost_cents => 200 },
                { :name => 'widget3', :cost_cents => 300 } ]
            end
          end
        end
        Widget.harmonize_default!
        Widget.remove_harmonizer!
        class Widget
          harmonize do |config|
            config.key = :name
            config.source = lambda do
              [ { :name => 'widget1', :cost_cents => 200 },
                { :name => 'widget2', :cost_cents => 200, :invalid_attribute => 'itis' },
                { :name => 'widget4', :cost_cents => 400 } ]
            end
          end
        end
      end

      describe Harmonize::Log do
        before(:each) do
          @log = Widget.harmonize_default!
        end

        it "should create 1" do
          @log.should be_a(Harmonize::Log)
        end

        it "should have 1 created" do
          @log.created.count.should == 1
        end

        it "should have 1 updated" do
          @log.updated.count.should == 1
        end

        it "should have 1 destroyed" do
          @log.destroyed.count.should == 1
        end

        it "should have 1 errored" do
          @log.errored.count.should == 1
        end

      end

      describe Harmonize::Modification do

        it "should create 4" do
          expect { Widget.harmonize_default! }.to change(Harmonize::Modification, :count).by(4)
        end

      end

      describe Widget do

        it "should not have changed count since one was created and one was destroyed" do
          expect { Widget.harmonize_default! }.to change(Widget, :count).by(0)
        end

      end

    end
  end
end
