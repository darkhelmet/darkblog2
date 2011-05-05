module Taggable
  module InstanceMethods
    def tags=(t)
      write_attribute(:tags, t.uniq)
    end

    def tag_string
      tags.to_a.join(', ')
    end

    def tag_string=(tags)
      # TODO: Some piping DSL like "tags.split(',') | :strip | :empty?.reject | :parameterize"
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