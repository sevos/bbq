# encoding utf-8

require 'test_helper'
require 'capybara/rails'
require 'bbq/test_user'
require 'bbq/devise'

class DeviseTestUser < Bbq::TestUser
  include Bbq::Devise
end

class BbqTwoSimultaneousUsersTest < Test::Unit::TestCase

  Text = "BBQ"

  def teardown
    User.find_by_email(@andy.email).try(:destroy)
    User.find_by_email(@dhh.email).try(:destroy)
  end

  def test_user_register
    @andy = DeviseTestUser.new
    @dhh =  DeviseTestUser.new

    @andy.register
    @dhh.register

    @andy.see?(Text)
    @dhh.see?(Text)

    @andy.logout
    @dhh.logout

    @andy.not_see?(Text)
    @dhh.not_see?(Text)

    @andy.login
    @andy.see?(Text)
    @dhh.not_see?(Text)

    @dhh.login
    @andy.see?(Text)
    @dhh.see?(Text)

    @andy.logout
    @andy.not_see?(Text)
    @dhh.see?(Text)

    @dhh.logout
    @andy.not_see?(Text)
    @dhh.not_see?(Text)
  end

end

