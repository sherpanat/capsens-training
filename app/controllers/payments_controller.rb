class PaymentsController < ApplicationController
  def new
    @card_attributes = card_params
  end

  private

  def card_params
    params.require(:card_attributes).permit(:Id, :AccessKey, :CardRegistrationURL, :PreregistrationData)
  end
end