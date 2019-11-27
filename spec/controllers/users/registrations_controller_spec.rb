RSpec.describe Users::RegistrationsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "assigns new User" do
      get :new
      expect(assigns(:resource)).to be_a_new(User)
    end
  end

  describe "POST create" do
    subject { post :create, params: { user: user_attributes } }
    context "with valid attributes" do
      let(:user_attributes) { attributes_for(:user) }

      it "saves the new user" do
        expect { subject }
          .to change(User, :count).by(1)
      end

      it "responds 302" do
        subject
        expect(response.status).to eq(302)
      end

      it "redirects to root" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid attributes" do
      let(:user_attributes) { attributes_for(:user, first_name: '') }

      it "does not save the user" do
        expect { subject }
          .not_to change(User, :count)
      end

      it "render same page" do
        subject
        expect(response.status).to eq(200)
      end
    end
  end
end
