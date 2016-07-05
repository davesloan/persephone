module Persephone
  class App
    extend ::Mongoid::Document
    extend ::Mongoid::Timestamps

    embeds_one :authorization, class_name: 'Auth', inverse_of: :application

    field :name, String
    field :scopes, Array
    field :client_id, String
    field :client_secret, String

    validates :name, presence: true, uniqueness: true
    validates :client_id, presence: true, uniqueness: true
    validates :client_secret, presence: true

    index({ client_id: 1 }, { unique: true })
    index({ client_secret: 1 })

    before_validation :generate_id_and_secret

    private

    def generate_id_and_secret
      @client_id ||= Digest::SHA256.hexdigest(UUID.new.generate(:compact))
      @client_secret ||= Digest::SHA256.hexdigest(UUID.new.generate(:compact))
      @scopes ||= [::Persephone.config.default_scope]
    end
  end
end
