require 'rubygems'
require 'active_resource'

module Cucumber  
  module Mingle
    @invalid_cards = []
    
    def self.features(config, options)
      url = "#{options[:host]}/api/v2/projects/#{options[:project]}"
      Card.site, Card.filters = url, options[:filter]
      Card.user, Card.password = options[:user], options[:password]
      config.formats << ['Cucumber::Mingle::Formatter', config.out_stream]
    end
    
    def self.report_invaild_card(card)
      @invalid_cards << card
    end
        
    def self.summary(passed, failed, pending)  
      to_scenario = Proc.new {|s| Scenario.new(s)}
      @handler.call(@invalid_cards, passed.map(&to_scenario), failed.map(&to_scenario), pending.map(&to_scenario)) if @handler
    end  
    
    def self.results(&handler)
      @handler = handler
    end    
    
    class Scenario
      attr_reader :source, :card, :feature
      
      def initialize(source)
        @source = source
        @feature = source.feature rescue source.scenario_outline.feature
        @card = @feature.card
      end
    end    
                
    class Card < ActiveResource::Base
      def self.filters=(filters)
        @filters = filters
      end
      
      def self.find_by_number(number)
        card = self.find(number)
        card.id = card.number
        card
      end      
      
      def self.all        
        !@filters ? self.find(:all, :params=> {:page => 'all'}) : self.find(:all, :params => {:page => 'all', 'filters[mql]'.to_sym => @filters})
      end
      
      def type
        attributes['card_type_name']
      end

      def type=(type)
        attributes['card_type_name'] = type
      end
      
      def [](name)
        property = properties.find { |p| p.name == name }
        property.value if property
      end
      
      def []=(name, value)
        property = properties.find { |p| p.name == name }
        property.value = value if property
      end
    end
    
    class Formatter      
      def initialize(step_mother, io, options)
        @step_mother = step_mother
      end            
      
      def after_features(*args)
        Cucumber::Mingle.summary(@step_mother.scenarios(:passed), @step_mother.scenarios(:failed), @step_mother.scenarios(:undefined))
      end         
    end   
  end
end

class Cucumber::Runtime
  alias cucumber_features features 
  def features
    filters = []
    features = Cucumber::Ast::Features.new
    Cucumber::Mingle::Card.all.map do | card |
      feature_file = Cucumber::FeatureFile.new("#{card.number}-#{card.name}.feature", card.description)
      feature = feature_file.parse(filters, {}) rescue nil
      if feature
        class <<feature
          attr_accessor :card
        end
        feature.card = card
        features.add_feature(feature) 
      else
        Cucumber::Mingle.report_invaild_card(card)
      end
    end
    features
  end
end



