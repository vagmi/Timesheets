class ProjectsController < ApplicationController
  
  def index
    @users = User.all
    @projects = Project.all
  end

  def create
    @project=Project.new(params[:project])
    if @project.save
      redirect_to :action => 'index'
      else
      render 'index'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to :action => 'index'
      else
      redirect_to :back
    end
  end

end
