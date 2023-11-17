

class PersonController < ApplicationController
#  model :location, :person

#  before_filter :validate_person, :only => [:edit, :update, :do_change_pass]

  @person = ''

  def login
    if session[:person]
      reset_session
    end
  end

  def sign_on
    person = Person.authenticate( params[:person][:email],
                                  params[:person][:password])

    if person
      session[:person] = person
      if session[:url]
        redirect_to session[:url]
      else
        redirect_to :controller => "person", :action => "show", :id => session[:person].id
      end
      session[:url] = nil
    else
      flash[:notice] = "Login fehlgeschlagen."
      redirect_to :action => "login"
    end
  end

  def logout
    reset_session
    redirect_to :action => "login"
  end
  def login
  end

  def index
    redirect_to :action => "list"
  end

  # list all persons
  def list
    @persons = Person.find(:all, :order => :email )
  end

  # show information about a person
  def show
    begin
      @person = Person.find(params[:id])

      @locations = Location.find(:all,
                       :conditions => ["person_id = ?", params[:id]] ,
                     :order => "name"  )

    rescue ActiveRecord::RecordNotFound
      render_text "Error, Person not found"
    end
  end

  # edit a specific person identified by param person id
  def edit
    @person = Person.find(params[:id])
    if session[:person] != @person and !session[:person][:admin]
      flash[:notice] = 'Sie haben nicht die Berechtigung hierfür.'
      redirect_to :back
    end
  end

  # update the information about a person identified by person id
  def update
    @person = Person.find(params[:id])
    if session[:person] != @person and !session[:person][:admin]
      flash[:notice] = 'Sie haben nicht die Berechtigung hierfür.'
      redirect_to :back
    else
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person wurde erfolgreich upgedatet.'
        redirect_to :action => 'show', :id => @person
      else
        flash[:notice] = 'Person wurde NICHT verändert.'
        redirect_to :action => 'edit', :id => @person
      end
    end
  end

  def register
  end

  # create new person record
  def create
   if params[:password] == params[:password2]
      values = params[:person]
      values[:password] = params[:password]
      @person = Person.new(values)
      @person.password = params[:person][:password]
      if @person.save
        flash[:notice] = 'Person erfolgreich registriert'
        redirect_to :action => 'show', :id => @person
      else
        flash[:notice] = 'Eingaben inkorrekt formatiert oder anderer fehler'
        params[:person][:password2] = "";
        params[:person][:password] = "";
        render :action => 'register', :person => params[:person]
      end
    else
      flash[:notice] = 'Bitte überprüfen Sie ihre Eingabe'
      render :action => 'register', :person => params[:person]
    end
  end

  # revoke password form
  def revoke_pass
    reset_session
  end

  # generate new password and mail to the poor guy
  def do_revoke
    password = newpass( 8 )
    @person = Person.find( :first,
                           :conditions => [ "email = ?", params[:person][:email] ] )
    if @person == nil
      flash[:notice] = 'Die angegebene Email Adresse ist nicht registriert.'
      redirect_to :action => 'revoke_pass'
    elsif @person.update_attribute( 'password', password )
      mail = PasswordMailer.deliver_password( @person, password )
      flash[:notice] = 'Ihr neues Passwort wird Ihnen via email zugesendet.'
      redirect_to :action => 'login'
    else
      render :action => 'revoke_pass'
    end
  end

  def change_pass
    @person = Person.find(params[:id])
    if session[:person] != @person
      flash[:notice] = 'Sie haben nicht die Berechtigung hierfür.'
      redirect_to :back
    end
  end

  def do_change_pass
      person = Person.find( :first, :conditions =>
                      [ "email = BINARY ? AND password = BINARY ?",
                        session[:person][:email],
                        Digest::MD5.hexdigest(params[:oldpassword]) ] )
      if person and params[:password] == params[:password2]
        person.update_attribute( 'password', params[:password] )
	flash[:notice] = 'Ihr Passwort wurde geaendert.'
	redirect_to :action => 'show', :id => session[:person][:id]
      else
        flash[:notice] = 'Ihr altes Passwort wurde falsch eingegeben.'
	redirect_to :back
      end
  end


protected
  # validate rights of person
  def validate_person
    if session[:person] != @person
      flash[:notice] = 'Sie sind leider nicht berechtigt!'
      redirect_to :back
    end
  end

private
  # generate alphanumeric password
  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end
