module Admin
  class UserSessionsController < ApplicationController
    def create
      bypass_sign_in(User.find(params[:user_id]))
      redirect_to root_path
    end
  end
end