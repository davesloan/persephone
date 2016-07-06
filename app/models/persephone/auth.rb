module Persephone
  class Auth
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    embedded_in :application, class_name: 'App', inverse_of: :authorization

    field :expires, type: DateTime
    field :token, type: String

    validates :expires, presence: true
    validates :token, presence: true, uniqueness: true

    index({ token: 1 }, { unique: true })

    before_validation :generate_token, :generate_expires

    private

    def generate_token
      token ||= Digest::SHA256.hexdigest UUID.new.generate(:compact)
    end

    def generate_expires
      expires ||= Time.now.utc + 1.hour
    end
  end
end
