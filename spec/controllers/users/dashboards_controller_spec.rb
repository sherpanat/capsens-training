require 'rails_helper'

RSpec.describe Users::DashboardsController, type: :controller do
  describe "GET show" do
    context "if user logged in" do
      it "returns User info" do
        sign_in create(:user)
        get :show
        expect(response.status).to eq(200)
        expect(response).to render_template :show
      end
    end

    context "if no user logged in" do
      it "redirects to sign in page" do
        get :show
        expect(response.status).to eq(302)
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
