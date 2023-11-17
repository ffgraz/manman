class NodeController < ApplicationController
  model :person

  def index
    redirect_to :action => "list"
  end

  def list
    @location = @params[:location]
    if @location != nil
      @nodes = Node.find(:all,
                       :conditions => ["location_id = ?", Location.find_by_name(@params[:location]).id],
		       :order => 'location_id')
    else
      @nodes = Node.find(:all, :order => 'location_id')
    end
  end

  def destroy
  end

  def edit
    @persons = Person.find(:all)
    @node = Node.find(params[:id])
  end

  def update
    @node = Node.find(params[:id])
    values = params[:node]
    if values[:time] == nil
      values[:time] = 0
    end
    if ( session[:person] != @node.location.person ) and ( !session[:person][:admin] )
      flash[:notice] = 'Sie sind nicht berechtigt.'
      redirect_to :back
    else if @node.update_attributes(params[:node])
      flash[:notice] = 'Node erfolgreich geaendert'
      redirect_to :action => 'show', :controller => 'location', :id => @node.location
    else
      flash[:notice] = 'Änderung fehlgeschlagen'
      redirect_to :action => 'show', :controller => 'location', :id => @node.location
    end
    end
  end

  def new
    @persons = Person.find(:all)
    @location = Location.find(params[:location])
    @node = Node.new( :location_id => @location.id )
  end

  def do_new
    node_values = params[:node]
    node_values[:time] = DateTime.now.to_s()
    node_values[:creator_ip] = @request.env["REMOTE_ADDR"]

#    Nets.find(:first, :conditions =>

    location = Location.find(node_values[:location_id])
    if ( session[:person] != location.person ) and ( !session[:person][:admin] )
      flash[:notice] = 'Sie sind nicht berechtigt.'
      redirect_to :action => 'show', :controller => 'person', :id => session[:person].id
    elsif Node.create_node(node_values)
      flash[:notice] = 'Node erfolgreich erzeugt'
      redirect_to :action => "show", :controller => "location", :id => node_values[:location_id]
    else
      flash[:notice] = 'error'
      render_text 'error'
    end
  end
end
