module HyperKitten
  module Meow
    class User < ActiveRecord::Base
      include Concerns::Models::User
    end
  end
end
