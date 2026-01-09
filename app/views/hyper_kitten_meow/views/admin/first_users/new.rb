# frozen_string_literal: true

module HyperKittenMeow
  class Views::Admin::FirstUsers::New < Views::Admin::Base
    def initialize(user:)
      @user = user
    end

    def view_template
      section(class: "new-user") do
        h2 { "Welcome to #{t('hyper_kitten_meow.title')}" }
        p { "Please create your first user account to get started." }

        render Components::Form.new(model: @user, url: hyper_kitten_meow.admin_first_users_path, method: :post) do |f|
          f.text_field :name, required: true
          f.email_field :email, required: true
          f.password_field :password, required: true
          f.password_field :password_confirmation, required: true

          f.submit
        end
      end
    end
  end
end
