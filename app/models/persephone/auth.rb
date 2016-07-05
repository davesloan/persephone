module Persephone
  class Auth
    extend ::Mongoid::Document
    extend ::Mongoid::Timestamps

    embedded_in :application, class_name: Persephone.config.authorization_model, inverse_of: :authorization

    field :expires, DateTime
    field :token, String

    validates :expires, presence: true
    validates :token, presence: true, uniqueness: true

    index({ token: 1 }, { unique: true })

    before_validation :generate_token

    private

    def generate_token
      token ||= Digest::SHA256.hexdigest UUID.new.generate(:compact)
    end
  end
end
