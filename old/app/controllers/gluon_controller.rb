require 'digest'


class GluonController < ApplicationController
  @person = ''
  $secret = ENV["GLUON_SECRET"]
  $url = ENV["GLUON_URL"]

  def redirect
    @random = ((0...50).map { ('a'..'z').to_a[rand(26)] }.join).to_s
    @timestamp = DateTime.now().to_s
    @user = session[:person].id.to_s
    @hash = Digest::SHA512.hexdigest ("#{@random}#{@timestamp}#{$secret}#{@user}")
    @hash = @hash.to_s
    @url = "#{$url}/#{@user}/#{@random}/#{@timestamp}/#{@hash}"
    redirect_to(@url)
  end
end
