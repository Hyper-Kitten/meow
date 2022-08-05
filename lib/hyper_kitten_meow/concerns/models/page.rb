module HyperKittenMeow
  module Concerns
    module Models
      module Page
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable
        include Categorical::Taggable

        included do
          validates_presence_of :title, :body
          validates_length_of :title, maximum: 244

          before_save :set_published_at_date

          sluggify :slug, generated_from: :title

          has_rich_text :body
        end

        class_methods do
          def published
            where(published: true)
          end
        end

        private

        def set_published_at_date
          if published_changed?(from: false, to: true)
            self.published_at = Time.current
          end
        end
      end
    end
  end
end
