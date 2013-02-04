class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def ldap_form
  end
end
