module Persephone
  class TokensController < ApplicationController
    def token
      app = Persephone::App.find_by(client_id: params['client_id'], client_secret: params['client_secret'])
      if app
        app.authentication = Persephone::Auth.new
        app.save
        response = { token: app.authentication.token, expires: app.authentication.expires }
        code = 201
      else
        response = { error: 'Application not found or invalid client_secret.' }
        code = 401
      end
      render json: response, status: code
    end
  end
end
