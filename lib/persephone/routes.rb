require 'action_dispatch/routing'
require 'active_support/concern'

module ActionDispatch::Routing
  class Mapper
    def persephone
      match "oauth/token" => 'persephone/tokens#create', via: :post
    end
  end
end
