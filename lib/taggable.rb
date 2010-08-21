module Taggable
  module ClassMethods
  end

  module InstanceMethods
  end

  def self.configure(model)
    model.key :tags, Set
  end
end