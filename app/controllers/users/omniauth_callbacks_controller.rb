class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def ldap
     # We only find ourselves here if the authentication to LDAP was successful.
        ldap_return = request.env["omniauth.auth"]["extra"]["raw_info"]
        firstname = ldap_return.givenname[0].to_s
        lastname = ldap_return.sn[0].to_s
        displayname = ldap_return.displayname[0].to_s
        # TODO sAMAccountName is Windows specific, if we want to support generic
        # LDAP + AD we need to decide dynamically which field to used based on config
        username = ldap_return.uid[0].to_s
        # email = ldap_return.proxyaddresses[0][5..-1].to_s

        if @user = User.where(username: username).first
            sign_in_and_redirect @user
        else
            @user = User.create(:firstname => firstname,
                                :lastname => lastname,
                                :displayname => displayname,
                                :username => username,
                                # :email => email,
                                :password => User.generate_random_password)
            sign_in_and_redirect @user
        end
  end
end
