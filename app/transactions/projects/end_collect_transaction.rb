module Projects
  class EndCollectTransaction < ::BaseTransaction
    step :transfer_all_contributions_to_project_wallet

    def transfer_all_contributions_to_project_wallet(project)
      failed_collects = []
      contributions = project.contributions.payed.where.not(transfer_to_contribution_wallet_id: nil).each do |contribution|
        result = Contributions::CollectTransaction.call(contribution)
        failed_collects << result.failure[:transfer] if result.failure
        result.success
      end
      failed_collects.empty? ? Success(contributions) : Failure(failed_collects)
    end
  end
end
