# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :authenticate, :except => [ :login, :sign_on, :register, :create, :revoke_pass, :do_revoke, :smokeping, :all ]


protected
  def authenticate
    #session[:url] = url_for
    session[:url] = request.env["REQUEST_URI"]
    unless session[:person]
      redirect_to :controller => 'person',
                  :action => 'login'
    end
  end
end
