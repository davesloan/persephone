require 'uuid'
require 'digest'
require 'rails'

require File.expand_path('../persephone/version.rb', __FILE__)
require File.expand_path('../persephone/unauthorized_error.rb', __FILE__)
require File.expand_path('../persephone/engine.rb', __FILE__)

module Persephone
  DEFAULT_SCOPE = 'public'.freeze
end
