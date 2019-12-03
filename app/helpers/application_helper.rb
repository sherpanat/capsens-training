module ApplicationHelper
  def decorated_user
    @decorated_user ||= current_user&.decorate
  end
end
