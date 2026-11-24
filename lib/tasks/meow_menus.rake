namespace :meow do
  namespace :menus do
    desc "Expire every cached menu tree (run after changing page_path or how the app routes pages)"
    task expire: :environment do
      count = HyperKittenMeow::Menu.touch_all
      puts "Expired #{count} cached #{"menu".pluralize(count)}."
    end
  end
end
