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
    describe "with collect completed" do
      let(:project) { create(:project_with_counterparts, target_amount: 100) }
      it do
        project.prepare!
        project.publish!
        create(:contribution, project: project, amount: 200)
        expect(project).to transition_from(:ongoing).to(:success).on_event(:end_collect)
      end
    end

    describe "with collect not completed" do
      let(:project) { create(:project_with_counterparts, target_amount: 1_000_000) }
      it do
        project.prepare!
        project.publish!
        create(:contribution, project: project, amount: 100)
        expect(project).to transition_from(:ongoing).to(:failure).on_event(:end_collect)
      end
    end
  end

  context "Project scope: visibles" do
    let(:visible_projects) { Project.visibles }
    describe "includes upcoming projects" do
      let(:project) { create(:project) }
      it "is expected to include upcoming project" do
        project.prepare!
        expect(visible_projects).to include project
      end
    end

    describe "includes ongoing projects" do
      let(:project) { create(:project_with_counterparts) }
      it "is expected to include ongoing project" do
        project.prepare!
        project.publish!
        expect(visible_projects).to include project
      end
    end

    describe "includes successfull projects" do
      let(:project) { create(:project_with_counterparts, target_amount: 100) }
      it "is expected to include successfull project" do
        project.prepare!
        project.publish!
        create(:contribution, project: project, amount: 200)
        project.end_collect!
        expect(visible_projects).to include project
      end
    end

    describe "excludes drafted projects" do
      let(:project_attributes) { attributes_for(:project, short_description: '') }
      it "is expected to exclude drafted project" do
        expect(visible_projects).not_to include subject
      end
    end

    describe "excludes failed projects" do
      let(:project) { create(:project_with_counterparts, target_amount: 1_000_000) }
      it "is expected to exclude failed project" do
        project.prepare!
        project.publish!
        create(:contribution, project: project, amount: 100)
        project.end_collect!
        expect(visible_projects).not_to include project
      end
    end
  end
end
