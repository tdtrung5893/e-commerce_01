class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @q = User.ransack params[:q]
    @users = @q.result(distinct: true)
    respond_to do |format|
      format.html {@users = @users.page(params[:page]).per params[:limit]}
      format.csv {send_data @users.to_csv, filename:"users-#{Date.today}.csv"}
      format.xls {send_data @users.to_csv(col_sep: "\t")}
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user.destroy
      redirect_to admin_users_path, notice: t("user_deleted")
    else
      redirect_to admin_users_path,
        flash: { error: t("user_could_not_be_deleted") }
    end
  end
end
