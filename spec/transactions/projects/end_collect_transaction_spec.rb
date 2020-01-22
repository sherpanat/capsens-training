RSpec.describe Projects::EndCollectTransaction do
  subject { described_class.call(project) }

  context "End Collect when collect completed" do
    let(:project) { create(:project_with_counterparts, target_amount: 100) }

    describe "with transfers all successfull" do
      before "creates as many Mangopay::Transfer from contribution's wallet to project's wallet" do
        expect(MangoPay::Transfer).to receive(:create).twice.and_return("Id" => "1", "Status" => "SUCCEEDED")
      end

      it "returns contributions" do
        project
        project.prepare!
        project.publish!
        create(:contribution_payed, amount: 20, project: project).pay!
        contribution = create(:contribution_payed, amount: 90, project: project)
        contribution.pay!
        project.end_collect!
        result = subject.success
        expect(result).to be_an_instance_of(Array)
        expect(result.size).to eq(2)
        expect(result).to include(contribution)
      end
    end

    describe "with at least one failed transfer" do
      before "creates as many Mangopay::Transfer from contribution's wallet to project's wallet" do
        expect(MangoPay::Transfer).to receive(:create).twice.and_return("Id" => "1", "Status" => "FAILED")
      end

      it "returns failed transfers" do
        project
        project.prepare!
        project.publish!
        create(:contribution_payed, amount: 20, project: project).pay!
        contribution = create(:contribution_payed, amount: 90, project: project)
        contribution.pay!
        project.end_collect!
        result = subject.failure
        expect(result).to be_an_instance_of(Array)
        expect(result.size).to eq(2)
        expect(result.first["Id"]).to eq("1")
      end
    end
  end
end
