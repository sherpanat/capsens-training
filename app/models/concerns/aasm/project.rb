module Aasm
  module Project
    extend ActiveSupport::Concern
    included do
      include AASM
      aasm whiny_transitions: false

      aasm do
        state :draft, initial: true
        state :upcoming, :ongoing, :success, :failure

        event :prepare do
          transitions from: :draft, to: :upcoming, guard: :ready_for_preparation?
        end

        event :publish do
          transitions from: :upcoming, to: :ongoing, guard: :ready_for_publishing?
        end

        event :end_collect do
          transitions from: :ongoing, to: :success, guard: :project_completed?
          transitions from: :ongoing, to: :failure
        end
      end
    end

    def ready_for_preparation?
      name? && short_description? && long_description? && thumbnail && landscape
    end

    def ready_for_publishing?
      category && (counterparts.count > 0)
    end

    def project_completed?
      decorate.percentage_of_completion >= 100
    end
  end
end
