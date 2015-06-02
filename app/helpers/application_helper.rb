# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ifnil(value=nil)
    yield
    rescue NoMethodError
    raise unless $!.message =~ /:NilClass$/
    value
  end


end
