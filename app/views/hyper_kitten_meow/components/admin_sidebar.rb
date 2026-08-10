# frozen_string_literal: true

module HyperKittenMeow
  class Components::AdminSidebar < Components::Sidebar
    def default_menu
      section "Manage"
      menu do
        item "Posts", hyper_kitten_meow.admin_posts_path, icon: "newspaper"
        item "Pages", hyper_kitten_meow.admin_pages_path, icon: "file-text"
        item "Tags",  hyper_kitten_meow.admin_tags_path,  icon: "tag"
        item "Users", hyper_kitten_meow.admin_users_path, icon: "users"
      end
    end
  end
end
