class Admin::CreateFormsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @create = CreateForm.new
  end

  def create
    byebug
    @create = CreateForm.new create_params
    if @create.register
      flash[:success] = t "product_created"
      redirect_to root_url
    else
      flash[:danger] = t "create_product_failed"
      render :new
    end
  end

  private

  def create_params
    params.require(:create_form).permit :name, :category_id, :price, :description,
      :image_url
      # :screen, :camera, :cpu, :ram, :rom, :pin
  end
end
