require 'spec_helper'

describe Harmonize do

  describe ".harmonize" do

    context "default configuration" do

      before(:each) do
        Widget.remove_harmonizer!
        class Widget
          harmonize
        end
      end

      it "should be a Harmonize::Configuration" do
        Widget.harmonizers[:default].should be_a(Harmonize::Configuration)
      end

      it "should use the harmonizer name :default" do
        Widget.harmonizers.should have_key(:default)
      end

      it "should use the harmonizer key :id" do
        Widget.harmonizers[:default].should respond_to(:key)
        Widget.harmonizers[:default][:key].should == :id
      end

      it "should use the default callable harmonizer source" do
        Widget.harmonizers[:default].should respond_to(:source)
        Widget.harmonizers[:default][:source].should respond_to(:call)
      end

      it "should use the default callable harmonizer target" do
        Widget.harmonizers[:default].should respond_to(:target)
        Widget.harmonizers[:default][:target].should respond_to(:call)
      end

      it "should have return an ActiveRecord::Relation when target called" do
        Widget.harmonizers[:default][:target].call.should be_a(ActiveRecord::Relation)
      end

      it "should have the default harmonizer strategy" do
        Widget.harmonizers[:default].should respond_to(:strategy)
        Widget.harmonizers[:default][:strategy].should == Harmonize::Strategies::BasicCrudStrategy
      end

      it "should have the default harmonizer strategy arguments" do
        Widget.harmonizers[:default].should respond_to(:strategy_arguments)
        Widget.harmonizers[:default][:strategy_arguments].should == {}
      end

      it "should create define .harmonize_default!" do
        Widget.should respond_to(:harmonize_default!)
      end

      context "harmonize source method undefined" do

        it "should raise an error" do
          expect { Widget.harmonize_default! }.to raise_error(Harmonize::HarmonizerSourceUndefined)
        end

      end

      context "harmonize source method defined" do

        before(:each) do
          class Widget
            def self.harmonize_source_default
            end
          end
        end

        it "should not raise an error" do
          expect { Widget.harmonize_default! }.to_not raise_error(Harmonize::HarmonizerSourceUndefined)
        end

      end
    end
  end
end
