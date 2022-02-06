module HyperKitten
  module Meow
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
