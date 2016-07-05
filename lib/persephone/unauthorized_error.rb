module Persephone
  class UnauthorizedError < StandardError
    def initialize
      super('Application is not authorized: invalid token or scope.')
    end
  end
end
