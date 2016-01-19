Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'],
            secure_image_url: true,
            :client_options => {
              :ssl => {
                :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt",
                :ca_path => ENV['SSL_CERT_FILE']
              }
            }

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
            scope: 'public_profile', info_fields: 'id,name,link', secure_image_url: true,
            :client_options => {
              :ssl => {
                :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt"
              }
            }

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'],
            scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google', secure_image_url: true,
            :client_options => {
              :ssl => {
                :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt",
                :ca_path => ENV['SSL_CERT_FILE']
              }
            }

  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'],
            scope: 'r_basicprofile w_share',
            fields: ['id', 'first-name', 'last-name', 'location', 'picture-url', 'public-profile-url'],
            secure_image_url: true,
            :client_options => {
              :ssl => {
                :ca_file => ENV['SSL_CERT_FILE'] +"/ca-bundle.crt",
                :ca_path => ENV['SSL_CERT_FILE']
              }
            }


  # OmniAuth.config.on_failure = Proc.new do |env|
  #   SessionsController.action(:auth_failure).call(env)
  # end

end