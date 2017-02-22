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
end
