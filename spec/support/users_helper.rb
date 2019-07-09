def log_in_as(user, password: 'password', remember_me: true)
  visit login_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: password
  check 'session_remember_me' if remember_me
  click_button 'Log in'
end

def logout
  click_link 'Log out'
end

def force_logout
  page.driver.submit :delete, logout_path, {}
end
