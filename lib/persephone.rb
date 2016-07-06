require 'uuid'
require 'digest'

require File.expand_path('../persephone/version.rb', __FILE__)
require File.expand_path('../persephone/unauthorized_error.rb', __FILE__)
require File.expand_path('../persephone/routes.rb', __FILE__)
require File.expand_path('../persephone/engine.rb', __FILE__)

module Persephone
  DEFAULT_SCOPE = 'public'.freeze

  def self.authorized?(headers, scopes = [DEFAULT_SCOPE])
    auth = self.authorization(headers)
    auth && self.in_scope?(auth.app, scopes) && !self.expired?(auth)
  end

  def self.authorization(headers)
    token = auth_token(headers)
    if token
      app = App.where('auth.token' => token).first
      raise UnauthorizedError.new('token not found') if app.nil?
      app.auth
    else
      raise UnauthorizedError.new('invalid token')
    end
  end

  def self.current_application(headers)
    token = auth_token(headers)
    if token
      app = App.where('auth.token' => token).first
    else
      nil
    end
  end

  def self.expired?(auth)
    if auth.expires < Time.now.utc
      raise UnauthorizedError.new('token has expired; please get a new one')
    else
      false
    end
  end

  def self.authenticate(client_id, client_secret)
    app = App.where(client_id: client_id, client_secret: client_secret).first
    if app
      app.auth&.destroy
      app.auth = Auth.create(app: app)
      app.save
    end
    app
  end

  def self.in_scope?(app, scopes)
    if !(app.scopes & scopes).empty?
      true
    else
      raise UnauthorizedError.new('application does not have access (scope)')
    end
  end

  def self.auth_token(headers)
    return headers['Authorization'].split[1] unless headers.nil? || headers['Authorization'].nil?
    return false
  end

end
