module HyperKittenMeow
  class User < ActiveRecord::Base
    include ::HyperKittenMeow::Concerns::Models::User
  end
end
