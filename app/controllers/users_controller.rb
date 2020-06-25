class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    redirect_to books_path unless @user.id == current_user.id
    change_layout
  end

  private
  def change_layout
    render layout: 'admin_application' if current_user.admin?
  end

  def change_layout_render(action)
    current_user.admin? ? (render action, layout: 'admin_application') : (render action)
  end
end