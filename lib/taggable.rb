module Taggable
  module InstanceMethods
    def tags=(t)
      self.tags = Set.new(t).to_a
    end

    def tag_string
      tags.to_a.join(', ')
    end

    def tag_string=(tags)
      self.tags = tags.split(',').map(&:strip).reject(&:empty?).map(&:parameterize)
    end
  end

  def self.included(klass)
    klass.field :tags, :type => Array, :default => []
    klass.instance_eval do
      scope(:by_tag, ->(tag) {
        where(:tags.in => [tag])
      })
    end
    klass.send(:include, InstanceMethods)
  end
end