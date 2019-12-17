module ExceptionHandling
  extend ActiveSupport::Concern

  included do
    around_action :catch_exceptions
  end

  private

  def catch_exceptions
    yield
  rescue ActiveRecord::RecordNotFound
    render :file => "#{Rails.root}/public/404.html", status: 404
  end
end
