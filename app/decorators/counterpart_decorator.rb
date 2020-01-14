class CounterpartDecorator < ApplicationDecorator
  delegate_all

  def description_with_threshold
    I18n.t('decorators.counterpart.description_with_threshold', description: description, threshold: threshold)
  end
end
