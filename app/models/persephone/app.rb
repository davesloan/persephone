module Persephone
  class App
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    embeds_one :auth, class_name: 'Persephone::Auth'

    field :name, type: String
    field :scopes, type: Array
    field :client_id, type: String
    field :client_secret, type: String
    field :rate_limit, type: Boolean, default: true
    field :app_id, type: Integer, default: 0
    field :app_slug, type: String

    validates :name, presence: true, uniqueness: true
    validates :client_id, presence: true, uniqueness: true
    validates :client_secret, presence: true

    index({ client_id: 1 }, { unique: true })
    index({ client_secret: 1 })
    index({ app_id: 1 })
    index({ app_slug: 1 })

    default_scope -> { ascending(:name) }

    before_validation do
      self.client_id ||= Digest::SHA256.hexdigest(UUID.new.generate(:compact))
      self.client_secret ||= Digest::SHA256.hexdigest(UUID.new.generate(:compact))
      self.scopes ||= [Persephone::DEFAULT_SCOPE]
    end
  end
end
