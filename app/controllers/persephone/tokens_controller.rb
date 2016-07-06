module Persephone
  class TokensController < ActionController::Base

    def create
      app = ::Persephone.authenticate(params['client_id'], params['client_secret'])
      if app
        response = { token: app.auth.token, expires: app.auth.expires }
        code = 201
      else
        response = { error: 'unable to authenticate' }
        code = 401
      end
      render json: response, status: code
    end
  end
end
