class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success, :info, :warning, :danger

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:sex, :birthday, :notification])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :sex, :birthday, :notification])
  end

  private
  def require_admin
    redirect_to books_url, warning: "管理者権限がありません。" unless current_user.admin?
  end

  def login_required
    redirect_to new_user_session_path, warning: 'ログインしていません。' unless current_user
  end

  def change_layout
    if current_user.admin?
      layout "admin_application"
    else
      layout "application"
    end
  end
end
