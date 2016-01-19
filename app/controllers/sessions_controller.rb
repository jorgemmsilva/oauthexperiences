class SessionsController < ApplicationController
  def create

    # req = request.env['omniauth.auth']
    # raise req.inspect
    #raise request.inspect
    

    # access_token = request.env['omniauth.auth']['token']
    # RestClient.post 'https://graph.facebook.com/me/feed', { :access_token => access_token, :message => "hello world", :client_options => {
    #           :ssl => {
    #             :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt",
    #             :ca_path => ENV['SSL_CERT_FILE']
    #           }
    #         }} 

    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
    rescue
      flash[:warning] = "There was an error while trying to authenticate you..."
    end
    redirect_to root_path
  end

  def destroy
    if current_user
      session.delete(:user_id)
      flash[:success] = 'See you!'
    end
    redirect_to root_path
  end

  def auth_failure
    redirect_to root_path
  end

  def post
    return if current_user.nil?

    case current_user.provider
      when 'twitter'
        raise 'twitter'
      when 'facebook'
        post_facebook
      when 'google'
        raise 'google'
      when 'linkedin'
        raise 'linkedin'
      else
        raise 'else'
    end
  end

private
  
  def post_facebook
    request_url = "https://www.facebook.com/dialog/feed?app_id=#{ENV['FACEBOOK_KEY']}&amp;display=popup&amp;caption=An%20example%20caption&amp;link=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2F&amp;redirect_uri=https://pacific-brushlands-9551.herokuapp.com"
    #RestClient.post(request_url ,{:client_options => {:ssl => {:ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt"}}}) 
    RestClient::Request.execute(:url => request_url, :method => :post, :verify_ssl => false)

    # RestClient::Resource.new(
    #   request_url,
    #   :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read("#{ENV['SSL_CERT_FILE']}/cert.pem")),
    #   :ssl_ca_file      =>  "#{ENV['SSL_CERT_FILE']}/ca_certificate.pem",
    #   :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
    # ).get


#:ssl => {:ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt"}

    # dummy_response = RestClient.post("https://www.facebook.com/dialog/feed", 
    #                 {
    #                   verify_ssl: false,
    #                   display: 'popup',
    #                   caption: 'example caption',
    #                   link: 'https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2F',
    #                   redirect_uri: 'http://127.0.0.1:8080/',
    #                   :client_options => {
    #           :ssl => {
    #             :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt",
    #             :ca_path => ENV['SSL_CERT_FILE']
    #           }
    #         }
    #                 })

  end



end