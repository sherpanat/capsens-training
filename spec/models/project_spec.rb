RSpec.describe Project do
  subject { described_class.create(project_attributes) }

  context "Project initialization" do
    let(:project) { Project.new }
    it { expect(project).to have_state(:draft) }
  end

  context "Project preparation" do
    describe "with required params" do
      let(:project) { create(:project) }
      it { expect(project).to allow_event :prepare }
    end
    describe "without required params" do
      let(:project_attributes) { attributes_for(:project, short_description: '') }
      it { expect(subject).not_to allow_event :prepare }
    end
  end

  context "Project publication" do
    describe "with required params" do
      let(:project) { create(:project_with_counterparts) }
      it do
        project.prepare!
        expect(project).to allow_event :publish
      end
    end
    describe "without required params" do
      let(:project) { create(:project, category: nil) }
      it do
        project.prepare!
        expect(project).not_to allow_event :publish
      end
    end
  end

  context "Project end of collect" do
  end
end
