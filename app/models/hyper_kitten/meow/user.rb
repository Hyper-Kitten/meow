module HyperKitten
  module Meow
    class User < ActiveRecord::Base
      include ::HyperKitten::Meow::Concerns::Models::User
    end
  end
end
