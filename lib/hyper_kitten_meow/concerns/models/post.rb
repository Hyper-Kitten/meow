module HyperKittenMeow
  module Concerns
    module Models
      module Post
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable
        include Categorical::Taggable

        included do
          belongs_to :user

          validates_presence_of :title, :body, :user
          validates_length_of :title, maximum: 244

          before_save :set_published_at_date

          sluggify :slug, generated_from: :title

          has_rich_text :body
        end

        class_methods do
          def published
            where(published: true)
          end

          def sorted_by_published_date
            order(published_at: :desc)
          end
        end

        def css_classes
          if published?
            return "published"
          else
            return "not-published"
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
