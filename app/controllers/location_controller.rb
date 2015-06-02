class LocationController < ApplicationController
#  model :person, :location

  def index
    redirect_to :action => "list"
  end

  def list
    @person = @params[:person]
    if @person != nil
      @locations = Location.find(:all,
                       :conditions => ["person_id = ?", Person.find(:first, 
                                                                    :conditions => { :email => @person }).id],
                       :order => "name" )
    else
      @locations = Location.find(:all, :order => 'name' )
    end
  end


  def edit
    @location = Location.find(params[:id])
    @persons = Person.find(:all)
    if ( session[:person] != @location.person ) and ( session[:person].email != 'nine@wirdorange.org' )
      flash[:notice] = 'Sie haben nicht die Berechtigung hierfür.'
      redirect_to :back
    end
  end

  def update
    @location = Location.find(params[:id])
    values = params[:location]
    values[:time] = DateTime.now
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location wurde erfolgreich upgedatet.'
      redirect_to :action => 'show', :id => @location
    else
      flash[:notice] = 'Keine Änderung möglich.'
      redirect_to :action => 'edit', :id => @location
    end
  end

  def destroy
    render_text 'aktion nicht verfügbar'
  end

  # show inforomation of location
  # parameters:
  # id = location_id
  def show
    begin
     
      @location = Location.find(params[:id])
      @person = @location.person
      @nodes = Node.find(:all, :conditions => ["location_id=?", params[:id]] )
      @nets = Nets.find(:all, :conditions => ["location_id=?", params[:id]] )
      @googlemap = 'https://karte.graz.funkfeuer.at/?'
      @googlemap += "lng=#{@location.lon}"
      @googlemap += "&lat=#{@location.lat}"
      @googlemap += "&res=17"
      @googlemap += "&marker=all"

    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Error, Location with ID #{params[:id]} not found!"
      redirect_to :action => 'list'
    end
  end

  # display 'new location' form
  def new
    begin
      if params[:c] == nil or params[:r] == nil or params[:z_x] == nil or params[:z_y] == nil
        @location = Location.new(:pixel_x => params[:x], :pixel_y => params[:y] )
      else
	x = params[:c].to_i * 100 + params[:z_x].to_i;
	if x < 0
		x += 100;
	end
        @location = Location.new(:pixel_x => x ,
                               :pixel_y => params[:r].to_i * 100 + params[:z_y].to_i )
      end
    end
  end


  # create new location
  def create
    begin
      values = params[:location]
      values[:time] = DateTime.now
      values[:creator_ip] = @request.env["REMOTE_ADDR"]


      values[:person_id] = session[:person].id

      @location = Location.new(values)
      if @location.save
        flash[:notice] = 'Location gespeichert'
        redirect_to :action => 'show', :id => @location
      else
        flash[:notice] = 'Location nicht gespeichert, bitte ueberpruefen Sie Ihre Eingabe'
        redirect_to :back
      end
    end
  end
end



