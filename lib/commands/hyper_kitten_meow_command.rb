require "rails/command"

class HyperKittenMeowCommand < Rails::Command::Base
  desc 'create_user', 'Creates an admin user'
  def create_user
    boot_application!
    name = ask("What is your name?")
    email = ask("What is your email address?")
    password = ask("Please choose a password.", echo: false)
    say("\n")
    password_confirmation = ask("Please confirm your password.", echo: false)

    ::HyperKittenMeow::User.create!(
      name: name, email: email, password: password,
      password_confirmation: password_confirmation
    )
  end

  desc "list_users", "Lists all the admin users"
  def list_users
    boot_application!
    users = ::HyperKittenMeow::User.all
    users = users.map do |user|
      [user.name, user.email]
    end
    say("HyperKitten users")
    print_table(users)
  end

  desc "delete_user", "Deletes a user with a given email address."
  def delete_user(email)
    boot_application!
    user = ::HyperKittenMeow::User.find_by_email(email)
    if user.destroy!
      say("Removed #{user.name}.")
    end
  end
end
