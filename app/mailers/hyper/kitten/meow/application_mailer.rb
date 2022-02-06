module Hyper
  module Kitten
    module Meow
      class ApplicationMailer < ActionMailer::Base
        default from: "from@example.com"
        layout "mailer"
      end
    end
  end
end
