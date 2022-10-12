module HyperKittenMeow
  module MenuHelper
    def menu(slug)
      HyperKittenMeow::Menu.find_by_slug(slug)
    end
  end
end
