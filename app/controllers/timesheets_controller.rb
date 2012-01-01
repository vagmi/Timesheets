class TimesheetsController < ApplicationController
  
  autocomplete :projects, :name
  
  def index
    @timesheets = TimeEntry.where(:user_id => current_user.id, :date => Date.today)
    @projects = Project.all
    @categories = Category.all
  end
  
  def create
    @timesheets = params[:timeentry]
    
    @timesheets.each do |sheet|
      if !sheet["entry_id"].nil?
          @time_entry = TimeEntry.find(sheet["entry_id"])
          sheet.delete("entry_id")
          @time_entry.update_attributes(sheet)
          flash.now[:success] = "Records Updated Successfully!"
        else

        sheet["user_id"]= current_user.id
        sheet["date"] = params[:task_date]
        data = TimeEntry.new(sheet)

        data.save!
      end
    end
    
    render :text => "success"
    
  end
  
  def destroy
    @timeentry = TimeEntry.find(params[:id])
    if @timeentry.destroy
      redirect_to :action => "index"
    else
      redirect_to :action => "index"
    end
    
  end
  
  def load_timesheet
    date = params[:date]
    @projects = Project.all
    @categories = Category.all
    @timesheets = TimeEntry.where(:date => date, :user_id => current_user.id)
    respond_to do |format|
      format.js
    end
  end
  
end
