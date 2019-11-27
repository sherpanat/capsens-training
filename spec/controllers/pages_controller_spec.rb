RSpec.describe PagesController do
  describe "GET #home" do
    it "response 200" do
      get :home
      expect(response.status).to eq(200)
    end
  end
end
