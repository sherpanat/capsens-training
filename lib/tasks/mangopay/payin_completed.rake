namespace :mangopay do
  task payin_completed: :environment do
    Contribution.pending.where.not(payin_id: nil).each do |contribution|
      payin_attributes = MangoPay::PayIn.fetch(contribution.payin_id)
      if payin_attributes["Status"] == "SUCCEEDED"
        Contributions::UpdateTransaction.call(contribution.attributes)
      elsif payin_attributes["Status"] == "FAILED"
        contribution.cancel!
      end
    end
  end
end
