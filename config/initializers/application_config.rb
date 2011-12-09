require 'ostruct'

module Darkblog2
  class << self
    def config
      @@config ||= OpenStruct.new(YAML.load(ERB.new(File.read(Rails.root.join('config', 'application.yml'))).result))
    end
  end
end