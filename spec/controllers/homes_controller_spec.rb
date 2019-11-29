RSpec.describe HomesController, type: :controller do
  describe "GET #show" do
    it "response 200" do
      get :show
      expect(response.status).to eq(200)
    end
  end
end
