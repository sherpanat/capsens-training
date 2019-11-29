module CurrentUserHandling
  private

  def current_user
      super&.decorate
  end
end
