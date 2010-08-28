module Taggable
  module InstanceMethods
    def tag_string
      tags.to_a.join(', ')
    end

    def tag_string=(tags)
      self.tags = tags.split(',').map(&:strip).map(&:parameterize)
    end
  end

  def self.included(klass)
    klass.field :tags, :type => Set, :default => Set.new
    klass.instance_eval do
      scope(:by_tag, lambda { |tag|
        any_in(:tags => [tag])
      })
    end
    klass.send(:include, InstanceMethods)
  end
end