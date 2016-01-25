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

      #raise request.env['omniauth.auth'].inspect

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

  def validate_post
    result = false
    case current_user.provider
      when 'twitter'
        raise 'twitter'
      when 'facebook'
        sleep 10
        result = validate_facebook
      when 'google'
        raise 'google'
      when 'linkedin'
        raise 'linkedin'
      else
        raise 'else'
    end

    if result
      render plain: "ta postado"
    else
      render plain: "neeeeem por isso"
    end

  end

  def successful_post
    render plain: "OK"
  end



private
  
  def post_facebook

    href = "google.com"
    redirect_uri = "https://pacific-brushlands-9551.herokuapp.com/post/validate"
    params = "app_id=#{ENV['FACEBOOK_KEY']}&display=popup&href=#{href}&redirect_uri=#{redirect_uri}"
    request_url = "https://www.facebook.com/dialog/share?" + params

    redirect_to request_url

  end

  def validate_facebook
    base_url = "https://graph.facebook.com/v2.5/me/feed?"
    params = "access_token=#{current_user.access_token}"
    profile = JSON.parse(RestClient.get(base_url+params))

    #raise profile.inspect

    posts = profile["data"].map{ |v| v["message"]}
    posts.each do |p|
      if p.include? "Alumniei"
        return true
      end
    end

    return false
  end



end