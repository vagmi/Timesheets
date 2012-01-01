class CategoriesController < ApplicationController
  
  before_filter :require_login
  
  def index
    @users = User.all
    @categories = Category.all
  end

  def create
    @category=Category.new(params[:category])
    if @category.save
      redirect_to :action => 'index'
      else
      render 'index'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to :action => 'index'
      else
      redirect_to :back
    end
  end
  
end
