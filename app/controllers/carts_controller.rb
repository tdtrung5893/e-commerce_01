class CartsController < ApplicationController
  before_action :get_product, only: :create

  def index
    if session[:order]
      current_order
      total_cart
      create_order
    end
  end

  def create
    unless session[:order].present?
      session[:order] = []
    end
    @product.promotion_details.each do |i|
      if Time.zone.today.between?(i.start_date, i.end_date)
        @percent = i.promotion.percent
      end
    end
    @price = sale_price_show(@product, @percent)
    @item = {"image_url": @product.images.first.image_url.url,
      "product_id": @product.id, "name": @product.name, "price": @price,
      "quantity": Settings.order_details.quantity.default}

    @item_index = session[:order].find_index {|n| n["product_id"] == @product.id}
    if @item_index.nil?
      session[:order] << @item
      total_cart
      @total_price += @item[:price] * @item[:quantity]
    else
      quantity = session[:order][@item_index]["quantity"]
      session[:order][@item_index]["quantity"] = quantity + 1
      total_cart
    end
    @carts = session[:order]
    respond_to do |format|
      format.html {redirect_to root_url}
      format.js
    end
  end

  def update
    session[:order].each do |item|
      if item["product_id"] == params[:id].to_i
        item["quantity"] = params["quantity"].to_i
        @product_id = item["product_id"]
        @quantity = item["quantity"]
        @sub_price = item["quantity"].to_i * item["price"]
      end
    end
    total_cart
    create_order
    respond_to do |format|
      format.js
    end
  end

  def destroy
    session[:order].delete_if{|item| item["product_id"] == params[:id].to_i}
    total_cart
    create_order
    respond_to do |format|
      format.js
    end
  end

  private

  def get_product
    redirect_to root_url unless @product = Product.find_by(id: params[:product_id])
  end
end
