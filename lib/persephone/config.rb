module Persephone
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  class Config
    attr_accessor :default_scope

    def initialize
      @default_scope = 'public'
    end
  end
end
