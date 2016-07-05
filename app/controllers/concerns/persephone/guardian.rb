module Persephone
  module Guardian
    extend ActiveSupport::Concern

    included do
      def authorized?(scopes = [::Persephone.config.default_scope])
        if auth_token
          auth = Object.const_get(::Persephone.config.authorization_model).find_by(token: auth_token)
          if auth && in_scope?(auth.application, scopes)
            @current_application = auth.application
            return true
          end
        end
        raise ::Persephone::UnauthorizedError
      end

      def current_application
        @current_application
      end

      private

      def in_scope?(app, scopes)
        !(app & scopes).empty?
      end

      def auth_token
        return params[:token] unless params[:token].nil?
        return request.headers['Authorization'].split[1] unless request.headers['Authorization'].nil?
        return false
      end

    end
  end
end
