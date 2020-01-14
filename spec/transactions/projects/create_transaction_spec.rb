RSpec.describe Projects::CreateTransaction do
  subject { described_class.call(project_attributes) }

  context "Create a project with valid attributes" do
    let(:category) { create(:category) }
    let(:project_attributes) { attributes_for(:project).merge(category_id: category.id) }
    before "Create a MangoPay::LegalUser" do
      expect(MangoPay::LegalUser).to receive(:create).with(
        Name: project_attributes[:name],
        LegalPersonType: "BUSINESS",
        LegalRepresentativeFirstName: project_attributes[:owner_first_name],
        LegalRepresentativeLastName: project_attributes[:owner_last_name],
        LegalRepresentativeBirthday: project_attributes[:owner_birthdate].to_time.to_i,
        LegalRepresentativeNationality: "FR",
        LegalRepresentativeCountryOfResidence: "FR",
        Email: project_attributes[:email]
      ).and_return("Id" => "1")
    end
    before "Create a MangoPay::Wallet" do
      expect(MangoPay::Wallet).to receive(:create).with(
        Owners: ["1"],
        Description: "Main wallet of the project",
        Currency: "EUR"
      ).and_return("Balance"=> { "Currency" => "EUR", "Amount" => 0 }, "Owners" => [project_attributes[:mangopay_id]], "Id" => "2")
    end
    it { expect { subject }.to change { Project.count }.by(1) }
    it "sets mangopay_id" do
      expect(subject.success.mangopay_id).to eq "1"
    end
    it "sets wallet_id" do
      expect(subject.success.wallet_id).to eq "2"
    end
  end

  context "Create a project with invalid attributes" do
    let(:project_attributes) { attributes_for(:project, name: '') }
    before "Does not create a MangoPay::LegalUser" do
      expect(MangoPay::LegalUser).not_to receive(:create)
    end
    before "Does not create a MangoPay::Wallet" do
      expect(MangoPay::Wallet).not_to receive(:create)
    end
    it { expect { subject }.not_to change { Project.count } }
  end
end
