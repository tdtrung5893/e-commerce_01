class StaticPagesController < ApplicationController
  def home
    @products = Product.get_product.page(params[:page]).
      per params[Settings.product.featured]
    @like_products = Product.like_most
  end

  def about
  end
end
