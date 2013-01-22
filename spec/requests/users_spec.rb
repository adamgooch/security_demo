require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user when password confirmation does not match password" do
        lambda do
          visit signup_path
          fill_in "Email", :with => "test@example.com"
          fill_in "Password", :with => "123456"
          fill_in "Confirmation", :with => "12345"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation", :content => "1 error")
        end.should_not change(User, :count)
      end

      it "should not make a new user when email is improperly formatted" do
        lambda do
          visit signup_path
          fill_in "Email", :with => "testexample.com"
          fill_in "Password", :with => "123456"
          fill_in "Confirmation", :with => "123456"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation", :content => "1 error")
        end.should_not change(User, :count)
      end

      it "should not make a new user when the password is too short" do
        lambda do
          visit signup_path
          fill_in "Email", :with => "test@example.com"
          fill_in "Password", :with => "12345"
          fill_in "Confirmation", :with => "12345"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation", :content => "1 error")
        end.should_not change(User, :count)
      end

      it "should not make a new user when the email already exists in the database" do
        visit signup_path
        fill_in "Email", :with => "test@example.com"
        fill_in "Password", :with => "123456"
        fill_in "Confirmation", :with => "123456"
        click_button
        lambda do
          visit signup_path
          fill_in "Email", :with => "test@example.com"
          fill_in "Password", :with => "123456"
          fill_in "Confirmation", :with => "123456"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation", :content => "1 error")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Email", :with => "test@example.com"
          fill_in "Password", :with => "123456"
          fill_in "Confirmation", :with => "123456"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => "Welcome to the Community!")
        end.should change(User, :count).by(1)
      end
    end
  end
end
