require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(
            name: 'Casu',
            email: 'info@casu-net.com.ar',
            password: '1234567',
            password_confirmation: '1234567'
        )
    end

    test "should be valid" do
        assert @user.valid?
    end

    test "name should be valid" do
        @user.name = "   " # invalid name
        assert_not @user.valid?
    end

    test "email should be valid" do
        @user.email = "   "
        assert_not @user.valid?
    end

    test "name should not be too long" do
        @user.name = "a" * 51
        assert_not @user.valid?
    end

    test "email should not be too long" do
        @user.email = "a" * 256
        assert_not @user.valid?
    end

    test "email address should reject invalid address" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            @user.email = invalid_address
            assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
        end
    end

    test "email address should be unique" do
        duplicate_user = @user.dup
        @user.save
        assert_not duplicate_user.valid?
    end

    test "email address should be saved as lower case" do
        mixed_case_email = "tEsTINg-EMAil@hoTmail.cOm"
        @user.email = mixed_case_email
        @user.save
        assert_equal mixed_case_email.downcase, @user.reload.email
    end

    test "password should not be too short" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
        assert_not @user.authenticated?('')
    end

end
