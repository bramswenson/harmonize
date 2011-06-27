# harmonize

hahr-muh-nahyz -

1.  to bring into harmony,  accord, or agreement: to harmonize one's views with the new situation.
2.  Music . to accompany with appropriate harmony.
3.  to be in agreement in action, sense, or feeling: Though of different political parties, all the delegates harmonized on civil rights.
4.  to sing in harmony.

harmonize is a rails 3 engine that allows one to harmonize entire scopes of an ActiveRecord model with arbitrary external data sources.

harmonize works by allowing one to setup feeds from external data called "sources". harmonize applies the "source" feeds to sets of ActiveRecord instances called "targets". These sets of "source" and "target" data are then handed of to a "strategy" to determine how to use the source to modify the target. When applying a "strategy" harmonize creates a Harmonize::Log which has_many Harmonize::Modifications. These records are then used to report information about the harmonize process.

## Simple Example

Lets pretend we work for a company that has a large list of stores. This list of stores in maintained in a database we don't have access to directly. The database administrator wrote a script to export the data in CSV format and upload it to our application. In our application we have a Store model but we always want it to be in harmony with the latest CSV file uploaded by the administrator. Every store has a unique name and an address, and the upstream database uses the name as the primary_key.

    class Store < ActiveRecord::Base
      validates :name, :address, :presence => true

      # Setup a harmonizer
      harmonize do |config|
        config.key = :name
      end

      # By default harmonize expects a class method to be implemented
      # that knows how to provide the source data feed
      def self.harmonize_source_default
        # parse the csv file and return
        # an collection of hash like objects
      end
    end

With our Store model wired up as above, we will get a new class method on our model called "harmonize_default!". When we call harmonize_default! harmonize will use the default strategy to harmonize the source records with the target records. In order to understand what actions are taken to bring the targets into harmony, we need to understand Harmonize::Strategies, but that is getting us ahead of ourselves. First lets look at how we configure harmonize.

## Harmonize::Configuration

Each call to harmonize creates a Harmonize::Configuration instance that defines how to configure a harmonizer. Here is an example using all the currently available configuration options using non-default settings:

    class Store < ActiveRecord::Base
      harmonize do |config|
        config.harmonizer_name    = :custom_name
        config.key                = :the_key
        config.source             = lambda do
          get_latest_source_data_feed!
        end
        config.target             = lambda do
          where(:active => true)
        end
        config.strategy           = YourCustomStrategy
        config.strategy_arguments = { :options => 'needed', :to => 'initialize', :your => 'custom strategy' }
      end
    end

### Harmonizer::Configuration.harmonizer_name

harmonize uses the configured harmonize_name as the name of the harmonizer being configured. Each harmonize_name may only be used once. This allows the harmonize method to be called more than once per model.

The default harmonizer_name is :default
This option is used to name special methods used by harmonize. The harmonization method is named with the following convention: "harmonize\_#{harmonizer\_name}!".

### Harmonizer::Configuration.key

harmonize uses the configured key to determine what attribute to use to find existing target records.

The default key is :id

### Harmonizer::Configuration.source

harmonize uses the configured source to gather the latest set of source records. This can be set to a lambda or any other callable object. The only requirement is that it returns a collection of hash like objects.

The default source is a lambda
This lambda calls the default source method who's name is determined by the harmonizer_name. The convention is: "harmonizer\_source\_#{harmonizer_name}".

### Harmonizer::Configuration.target

harmonize uses the configured target to gather the latest set of target records. This can be set to a lambda or any other callable object. The only requirement is that it returns an ActiveRecord::Relation

The default target is a lambda. This lambda returns an ActiveRecord::Relation via the ActiveRecord::Base#scoped method. Hint...all (named) scopes return ActiveRecord::Relation instances.

### Harmonizer::Configuration.strategy

harmonize uses the configured strategy to determine which Harmonize::Strategies::Strategy subclass to use when harmonizing. harmonize uses this setting as well as the strategy_arguments setting to create an instance of the Strategy subclass.

The default strategy is Harmonize::Strategies::BasicCrudStrategy

### Harmonizer::Configuration.target

harmonize uses the configured strategy_arguments to determine which arguments to use when initializing the set Harmonize::Strategies::Strategy subclass.

The default strategy is {}.

## Harmonize::Strategies

harmonize figures out how to use your source data to modify your target by using a Harmonize::Strategies::Strategy subclass. A strategy is responsible for determining when and how to create, update, and destroy your target records based on the source records.

The default harmonize strategy is Harmonize::Strategies::BasicCrudStrategy. This strategy assumes your source data to be a "source of truth" which reflects exactly how the entire target record set should look. Here are the steps it takes to achieve harmony:

1.  For each record in the source, use the configured "key" to find out if a record with that key already exists.
2.  If an existing record was found in target, update it with any attributes provided by source
3.  If no existing record was found in target, create a new record with any attributes provided by source
4.  Save the record and create a Harmonize::Modification record making if we created or updated
5.  If save has errors, update the Harmonize::Modification record to reflect that and store the error messages
6.  Save the key of the modified (or errored) record in a collection
7.  After all source records have been harmonized, destory any target record with a key not in the modified keys collection
8.  Save Harmonize::Log for reporting the actions took in this harmonization

Currently this is the only strategy provided by harmonize, but more will be added when I need them or you send them to me as a pull request.

## Installation and Usage

Add harmonize to the gem file for your rails application:

    gem 'harmonize'

Run the migration generator in your rails application root:

    rails generate harmonize:migration

Configure your model to use harmonize and implement your source:

    class MyModel < ActiveRecord::Base
      harmonize

      def self.harmonize_source_default
        # a collection of hash like objects
      end
    end

Bring your data into harmony

    MyModel.harmonize!(:default)
    # or the custom method named after your harmonizer
    MyModel.harmonize_default!

Use, report bugs, fix them, and send pull requests!

## Plans

## TODO

*  Maybe move key from Configuration to a strategy_argument as it is not a configuration option really, but a way to change stratgey behaviour.

## Contributors

*  Bram Swenson <bram@craniumisjar.com>

## Notes

Check out the rspec suite for more details about how harmonize works: [BasicCrudStrategy Spec](http://github.com/bramswenson/harmonize/blob/master/spec/lib/harmonize/strategies/basic_crud_strategy_spec.rb)

Please let me know how you use harmonize!

Thanks in advance!

## License

This project rocks and uses MIT-LICENSE.

