class CounterpartDecorator < ApplicationDecorator
  delegate_all

  def description_with_threshold
    I18n.t('models.counterpart.description_with_threshold', description: description, threshold: threshold)
  end
end
