module Persephone
  class UnauthorizedError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
