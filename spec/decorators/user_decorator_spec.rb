RSpec.describe UserDecorator do
  let(:user) { create(:user).decorate }
  describe "full_name" do
    it { expect(user.full_name).to eq("#{user.first_name} #{user.last_name}") }
  end
end
