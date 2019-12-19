RSpec.describe Contribution do
  subject { described_class.new(contribution_attributes) }

  context "Contribution must have a sufficient_amount_for_counterpart chosen" do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:counterpart) { create(:counterpart, project: project, threshold: 20) }
    describe "with counterpart in price range" do
      let(:contribution_attributes) { attributes_for(:contribution, amount: 20).merge(project_id: project.id, user_id: user.id, counterpart_id: counterpart.id) }
      it { expect(subject).to be_valid }
    end

    describe "with counterpart out of price range" do
      let(:contribution_attributes) { attributes_for(:contribution, amount: 10).merge(project_id: project.id, user_id: user.id, counterpart_id: counterpart.id) }
      it { expect(subject).not_to be_valid }
    end

    describe "without any counterpart" do
      let(:contribution_attributes) { attributes_for(:contribution).merge(project_id: project.id, user_id: user.id) }
      it { expect(subject).to be_valid }
    end
  end
end
