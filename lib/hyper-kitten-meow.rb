require "human_urls"
require "categorical"
require "pagy"
require "importmap-rails"
require "stimulus-rails"
require "propshaft"
require "phlex-rails"
require "hyper-kitten-tables"
require "lexxy"
require "hyper_kitten_meow/version"
require "hyper_kitten_meow/engine"
require "hyper_kitten_meow/menu_definition"
require "hyper_kitten_meow/components/base_page_template"
require "hyper_kitten_meow/components/table"
require "hyper_kitten_meow/concerns/models/content_block"
require "hyper_kitten_meow/concerns/models/user"
require "hyper_kitten_meow/concerns/models/post"
require "hyper_kitten_meow/concerns/models/page"
require "hyper_kitten_meow/concerns/models/menu"
require "hyper_kitten_meow/concerns/models/menu_item"
require "hyper_kitten_meow/concerns/controllers/pages_controller"
require "hyper_kitten_meow/concerns/controllers/posts_controller"
require "hyper_kitten_meow/concerns/controllers/admin/first_users_controller"
require "hyper_kitten_meow/concerns/controllers/admin/posts_controller"
require "hyper_kitten_meow/concerns/controllers/admin/pages_controller"
require "hyper_kitten_meow/concerns/controllers/admin/tags_controller"
require "hyper_kitten_meow/concerns/controllers/admin/users_controller"
require "hyper_kitten_meow/concerns/controllers/admin/menus_controller"
require "hyper_kitten_meow/concerns/controllers/admin/admin_controller"

module HyperKittenMeow
  Pagy.options[:limit] = 10

  def self.config
    Rails.application.config.hyper_kitten_meow
  end

  def self.menus
    MenuDefinition.from_config(config.menus)
  end

  def self.page_path(page)
    if (resolver = config.page_path)
      resolver.call(page)
    elsif Rails.application.routes.url_helpers.respond_to?(:page_path)
      Rails.application.routes.url_helpers.page_path(page.slug)
    else
      raise "Set config.hyper_kitten_meow.page_path: this app has no page_path route helper " \
            "for meow to link menu items to pages with."
    end
  end
end
