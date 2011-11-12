require 'spec_helper'

describe Harmonize do

  describe ".harmonize" do

    context "block configuration" do
      before(:each) do
        Widget.remove_harmonizer!(:not_default)
        class Widget
          harmonize do |config|
            config.harmonizer_name = :not_default
            config.key = :name
          end
        end
      end

      it "should be a Harmonize::Configuration" do
        Widget.harmonizers[:not_default].should be_a(Harmonize::Configuration)
      end

      it "should use the harmonizer name :not_default" do
        Widget.harmonizers.should have_key(:not_default)
      end

      it "should use the harmonizer key :name" do
        Widget.harmonizers[:not_default].should respond_to(:key)
        Widget.harmonizers[:not_default][:key].should == :name
      end

      it "should use the default callable harmonizer source" do
        Widget.harmonizers[:not_default].should respond_to(:source)
        Widget.harmonizers[:not_default][:source].should respond_to(:call)
      end

      it "should use the default callable harmonizer target" do
        Widget.harmonizers[:not_default].should respond_to(:target)
        Widget.harmonizers[:not_default][:target].should respond_to(:call)
      end

      it "should have return an ActiveRecord::Relation when target called" do
        Widget.harmonizers[:not_default][:target].call.should be_a(ActiveRecord::Relation)
      end

      it "should have the default harmonizer strategy" do
        Widget.harmonizers[:not_default].should respond_to(:strategy)
        Widget.harmonizers[:not_default][:strategy].should == Harmonize::Strategies::BasicCrudStrategy
      end

      it "should have the default harmonizer strategy arguments" do
        Widget.harmonizers[:not_default].should respond_to(:strategy_arguments)
        Widget.harmonizers[:not_default][:strategy_arguments].should == {}
      end

      it "should create define .harmonize_not_default!" do
        Widget.should respond_to(:harmonize_not_default!)
      end

      context "harmonizer source method undefined" do

        it "should raise an error" do
          expect{ Widget.harmonize_not_default! }.to raise_error(Harmonize::HarmonizerSourceUndefined)
        end

      end

      context "harmonizer source method defined" do

        before(:each) do
          class Widget
            def self.harmonize_source_not_default
            end
          end
        end

        it "should not raise an error" do
          expect{ Widget.harmonize_not_default! }.to_not raise_error(Harmonize::HarmonizerSourceUndefined)
        end

      end
    end
  end
end
