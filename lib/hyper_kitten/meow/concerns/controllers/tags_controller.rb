module HyperKitten
  module Meow
    module Concerns
      module Controllers
        module TagsController
          extend ActiveSupport::Concern

          def show
            @tag = Categorical::Tag.find_by_slug!(params[:id])
            @pagy, @taggables = pagy(@tag.
              send(fetch_taggable_type).
              published.
              sorted_by_published_date)
          end

          private

          def fetch_taggable_type
            if params[:type]
              taggable_type = params[:type]
              return taggable_type.underscore.to_sym
            else
              return "HyperKitten::Meow::Post"
            end
          end
        end
      end
    end
  end
end
