class ExportController < ApplicationController
  def smokeping
    @locations = Location.find(:all, :order => "name")
    if @locations != nil
      text = ""
      @locations.each do |location|
        @nodes = Node.find(:all, :conditions => { :location_id => location.id, :smokeping => true } )
        if @nodes != nil and not @nodes.empty?
          text += "++ #{location.name}\n"
          text += "menu = #{location.name}\n"
          text += "title = #{location.name} connectivity\n"
          @nodes.each do |node|
            text += "+++ #{node.name}\n"
            text += "menu = #{node.name}\n"
            text += "title = #{node.name} connectivity\n"
	    # prefer interfaces named wifi, even if they are not the first in the list 
            ip = Ip.find(:first, :conditions => ["node_id = ? AND name like ?", node.id, 'wifi%'])
            if ip != nil
              text += "host = #{ip.ip}\n"
	    else
		# no 'wifi' interface found, use any old interface...
            	ip = Ip.find(:first, :conditions => ["node_id = ?", node.id])
            	if ip != nil
              		text += "host = #{ip.ip}\n"
            	end
	    end
          end
        end
      end
      render_text text
    end
  end

  def all
    @locations = Location.find(:all, :order => "name")
    render :layout => false
  end
end
