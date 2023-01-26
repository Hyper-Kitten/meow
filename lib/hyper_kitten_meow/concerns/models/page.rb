module HyperKittenMeow
  module Concerns
    module Models
      module Page
        extend ActiveSupport::Concern
        include HumanUrls::Sluggable

        included do
          validates_presence_of :title, :body
          validates_length_of :title, maximum: 244
          validates_inclusion_of :template, in: templates, allow_blank: true

          before_save :set_published_at_date

          sluggify :slug, generated_from: :title

          has_rich_text :body
        end

        class_methods do
          def published
            where(published: true)
          end

          def templates
            templates_path = Rails.root.join("app/views/pages/templates/*")
            @templates = Dir.glob(templates_path).map do |path|
              File.basename(path).split(".").first
            end
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
