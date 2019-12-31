RSpec.describe Contributions::CreateTransaction do
  subject { described_class.call(contribution_attributes) }

  context "Create a contribution with valid attributes" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:counterpart) { create(:counterpart, project: project, threshold: 20) }
    let(:contribution_attributes) { attributes_for(:contribution, amount: 50).merge(user_id: user.id, project_id: project.id, counterpart_id: counterpart.id) }
    before "creates a MangoPay::CardRegistration" do
      expect(MangoPay::CardRegistration).to receive(:create).with(
        UserID: user.mangopay_id,
        Currency: 'EUR'
      ).and_return(
        "Id" => "123",
        "UserId" => user.mangopay_id,
        "AccessKey" => "1X0m87dmM2LiwFgxPLBJ",
        "PreregistrationData" => "S8HjKhXaPXeNlzbaHMqIv5ahx5EnS5jTkJowsAs6NUgDqe8Z5Lh ",
        "CardRegistrationURL" => "https://homologation-webpayment.payline.com/getToken",
        "Currency" => "EUR"
      )
    end
    it { expect { subject }.to change { Contribution.count }.by(1) }
    it "creates a contribution with a counterpart" do
      expect(subject.success[:contribution].counterpart).to eq(counterpart)
    end
  end

  context "Create a user with invalid attributes" do
    let(:contribution_attributes) { attributes_for(:contribution) }
    before "does not create a MangoPay::CardRegistration" do
      expect(MangoPay::CardRegistration).not_to receive(:create)
    end
    it { expect { subject }.not_to change { Contribution.count } }
  end
end
