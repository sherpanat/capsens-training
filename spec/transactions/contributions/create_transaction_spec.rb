RSpec.describe Contributions::CreateTransaction do
  subject { described_class.call(contribution_attributes) }

  context "Create a contribution with valid attributes" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:counterpart) { create(:counterpart, project: project, threshold: 20) }
    let(:contribution_attributes) { attributes_for(:contribution, amount: 50).merge(user_id: user.id, project_id: project.id, counterpart_id: counterpart.id) }
    it { expect { subject }.to change { Contribution.count }.by(1) }
    it "Create contribution with counterpart" do
      expect(subject.success.counterpart).to eq(counterpart)
    end
  end

  context "Create a user with invalid attributes" do
    let(:contribution_attributes) { attributes_for(:contribution) }
    it { expect { subject }.not_to change { Contribution.count } }
  end
end
