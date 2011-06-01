# Load the rails application
require File.expand_path('../application', __FILE__)

# Fucking rubygems
require 'yaml'
YAML::ENGINE.yamler= 'syck'

# Initialize the rails application
Darkblog2::Application.initialize!
