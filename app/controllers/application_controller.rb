class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def is_admin
  	if session[:admin].present?
  		unless u = User.where(role: 3).find_by_email(session[:admin])
        if u.verified == true && u.block == false
  			 redirect_to dashboard_signin_path
        else
          redirect_to dashboard_signin_path
        end
  		end
  	else
  		redirect_to dashboard_signin_path
  	end
  end

  def is_owner
  	if session[:owner].present?
  		unless u = User.where(role: 1).find_by_email(session[:owner])
        if u.verified == true && u.block == false
         redirect_to owner_signin_path
        else
          redirect_to dashboard_signin_path
        end
  		end
  	else
  		redirect_to owner_signin_path
  	end
  end

  def is_enduser
    if session[:user].present?
      unless u = User.where(role: 0).find_by_email(session[:user])
        if  u.block == false
         redirect_to '/' , notice: 'Error: Dont have access'
        else
          redirect_to '/' , notice: 'Error: Kindly Signin first'
        end
      end
      @end_user = u
    else
      redirect_to '/' , notice: 'Error: Kindly Signin first'
    end
  end

  def is_enduser_check
    if session[:user].present?
      unless u = User.where(role: 0).find_by_email(session[:user])
        if  u.block == false
         redirect_to '/' , notice: 'Error: Dont have access'
        else
          redirect_to '/' , notice: 'Error: Kindly Signin first'
        end
      end
      @end_user = u
    end
  end
end
