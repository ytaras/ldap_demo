class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def ldap
     # We only find ourselves here if the authentication to LDAP was successful.
        ldap_return = request.env["omniauth.auth"]["info"]
        puts request.env["omniauth.auth"].to_yaml
        firstname = ldap_return.first_name.to_s
        lastname = ldap_return.last_name.to_s
        displayname = ldap_return.name.to_s
        # TODO Not sure if it should be nickname (like 'john') or full qualified uid
        username = ldap_return.nickname.to_s
        email = ldap_return.email.to_s
        # email = "#{username}@mock.address"

        @user = User.find_or_create_by_ldap(
          username,
          firstname: firstname,
          displayname: displayname,
          lastname: lastname,
          email: email
        )
        sign_in_and_redirect @user
  end

  def failure
    # TODO I hate instanceof testing, but i see no other way
    is_ldap = request.env['omniauth.error.strategy'].kind_of? OmniAuth::Strategies::LDAP
    redirect_to ldap_form_user_path, :alert => request.env['omniauth.error.type'] if is_ldap
    # TODO Handle other ways of authentication
  end
end
