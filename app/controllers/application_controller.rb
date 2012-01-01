class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_monthname(mon)
    month_arr=%w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
    for i in 0..month_arr.length-1
      return month_arr[i] if mon-1==i
    end
  end
  
  def require_login
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_path
      return false
    end
  end
  
  
end
