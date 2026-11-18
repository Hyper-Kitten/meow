module Admin
  # A host-app admin screen that reuses Meow's admin login, as host apps do for their own records.
  class ReportsController < ApplicationController
    include HyperKittenMeow::Concerns::Controllers::Admin::AdminController

    def index
      render plain: "Reports"
    end
  end
end
