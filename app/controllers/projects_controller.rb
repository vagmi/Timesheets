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
  
  def show_my_statistics
    @user=current_user
    if request.xhr? && !params[:start_date].blank? && !params[:end_date].blank?
      @start_date=params[:start_date].to_date
      @end_date=params[:end_date].to_date
      #~ render :update do |page|
        #~ page.replace_html "bar_chart", :partial=>'my_statistics_chart'
      #~ end
      respond_to do |format|
        format.js
      end
    
    else
      @start_date=Date.current.beginning_of_month
      @end_date=Date.current
    end
  end
  
  def project_graph
    #if @project.user_id != current_user.id
      #redirect_to "/"
    #end
    @project = Project.find(params[:id])
    @start_date=Date.current.beginning_of_month
    @end_date=Date.current
    if request.xhr? && !params[:start_date].blank? && !params[:end_date].blank?
      @start_date=params[:start_date].to_date
      @end_date=params[:end_date].to_date
      #~ @user_id=params[:user_id]
      #render :update do |page|
        #page.replace_html "bar_chart", :partial=>'dynamic_chart', :locals => {:project => @project, :start_date => @start_date, :end_date => @end_date}
      #end
      respond_to do |format|
        format.js
      end
      
    end
  end
  
  def my_graph
    @params_arr=params[:id].split("_")
    @start_date=@params_arr[0].to_date
    @end_date=@params_arr[1].to_date
    @all_timeentries=TimeEntry.find_all_by_user_id(current_user.id)
    @timeentries=TimeEntry.where(['user_id=? and DATE(date)>=? and DATE(date)<=?',current_user.id,@start_date,@end_date]).order('project_id')
    project_arr=[]
    @all_timeentries && @all_timeentries.each do |time_ent|
      project_arr << time_ent.project
    end
    project_arr=project_arr.uniq.flatten
    bar = BarOutline.new(50, '#A9A9A9', '#9C0D12')
    bar.key("No. of Hours", 10)
    x_array=[]
    project_arr && project_arr.each do |prjct|
      tot=0
      @timeentries && @timeentries.each do |time_ent|
        if prjct.id==time_ent.project.id
          tot+=time_ent.minutes.to_f
        end
      end
      bar.add_data_tip(tot,"#{tot} hour(s)")
      #~ bar.data << tot
      x_array << prjct.name
    end
    if x_array.empty?
      x_array << "(None)"
    end
    g = Graph.new
    g.title("Statistics for #{current_user.email} from #{@start_date.strftime("%d %b %Y")} to #{@end_date.strftime("%d %b %Y")}", "{font-size: 12px;}")
    g.data_sets << bar
    g.set_tool_tip('#x_label# <br>#tip#')
    g.set_x_labels(x_array)
    g.set_x_label_style(10, '#9933CC', 2,1)
    g.set_x_axis_steps(2)
    g.set_x_legend("Project(s)", 12, "#736AFF")
    if !bar.data.empty?
      g.set_y_max(bar.data.max+10)
    end
    g.set_y_label_steps(10)
    g.set_y_legend("No. of Hours", 12, "#736AFF")
    render :text => g.render
  end
  
  def static_graph
    user_ids=[]
    @project = Project.find(params[:id])
    @timeentries_user=@project.time_entries.all(:order=>'user_id')
    @timeentries_user && @timeentries_user.each do |time_ent|
      user_ids<< time_ent.user.id
    end
    user_ids=user_ids.uniq.flatten
    @start_date= Date.current.beginning_of_month
    @end_date=Date.current.end_of_month
    @users=User.find(user_ids)
    @timeentries = TimeEntry.all(:conditions=>['user_id in (?) and project_id=? and DATE(date)>=? and DATE(date)<=?',user_ids,@project.id,@start_date.to_date,@end_date.to_date], :order=>['user_id'])
    bar = BarOutline.new(50, '#A9A9A9', '#9C0D12')
    bar.key("No. of Hours", 10)
    x_array=[]
    @users && @users.each do |u|
      tot=0
      @timeentries && @timeentries.each do |time_ent|
        if time_ent.user_id==u.id
          tot+=time_ent.minutes.to_f
        end
      end
      bar.add_data_tip(tot,"#{tot} hour(s)")
      #~ bar.data << tot
      x_array << u.email
    end
    if x_array.empty?
      x_array << "(None)"
    end
    g = Graph.new
    g.title("Statistics for #{@project.name} in #{get_monthname(Date.current.month)}-#{Date.current.year}", "{font-size: 12px;}")
    g.data_sets << bar
    g.set_tool_tip('#x_label# <br>#tip#')
    g.set_x_labels(x_array)
    g.set_x_label_style(10, '#9933CC', 2,1)
    g.set_x_axis_steps(2)
    g.set_x_legend("Employee(s)", 12, "#736AFF")
    if !bar.data.empty?
      g.set_y_max(bar.data.max+10)
    end
    g.set_y_label_steps(10)
    g.set_y_legend("No. of Hours", 12, "#736AFF")
    render :text => g.render
  end
  
  def dynamic_graph
    user_ids=[]
    @project = Project.find(params[:id])
    @timeentries_user=@project.time_entries.all(:order=>'user_id')
    @timeentries_user && @timeentries_user.each do |time_ent|
      user_ids<< time_ent.user.id
    end
    user_ids=user_ids.uniq.flatten
    @start_date= params[:start_date].to_date
    @end_date= params[:end_date].to_date
    @users=User.find(user_ids)
    @timeentries = TimeEntry.all(:conditions=>['user_id in (?) and project_id=? and DATE(date)>=? and DATE(date)<=?',user_ids,@project.id,@start_date,@end_date], :order=>['user_id'])
    bar = BarOutline.new(50, '#A9A9A9', '#9C0D12')
    bar.key("No. of Hours", 10)
    x_array=[]
    @users && @users.each do |u|
      tot=0
      @timeentries && @timeentries.each do |time_ent|
        if time_ent.user_id==u.id
          tot+=time_ent.minutes.to_f
        end
      end
      bar.add_data_tip(tot,"#{tot} hour(s)")
      #~ bar.data << tot
      x_array << u.email
    end
    if x_array.empty?
      x_array << "(None)"
    end
    g = Graph.new
    g.title("Statistics for #{@project.name} between #{@start_date.strftime("%d %b %Y ")} and #{@end_date.strftime("%d %b %Y ")}", "{font-size: 12px;}")
    g.data_sets << bar
    g.set_x_label_style(10, '#9933CC', 2,1)
    g.set_x_axis_steps(20)
    g.set_x_legend("Employee(s)", 12, "#736AFF")
    g.set_tool_tip('#x_label# <br>#tip#')
    g.set_x_labels(x_array)
    if !bar.data.empty?
      g.set_y_max(bar.data.max+10)
    end
    g.set_y_label_steps(10)
    g.set_y_legend("No. of Hours", 12, "#736AFF")
    render :text => g.render
  end


end
