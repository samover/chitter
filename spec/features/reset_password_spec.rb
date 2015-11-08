# As a Maker
# So that I can indulge in setting horrible passwords and forgetting them
# I want to be able to reset my password

feature 'Resetting password' do
  before do
    sign_up
    Capybara.reset!
  end

  let(:user) { User.first }

  # As a braindead zombie
  # So that I can reset my password
  # I want to see a link to reset my password
  scenario 'When I forget my password, I want to see a reset link' do
    visit '/sessions/new'
    click_link 'I forgot my password'
    expect(page).to have_content 'Please enter your email address'
  end

  # As a braindead zombie
  # So that I can reset my password
  # I can enter my email address and am told to check my inbox
  scenario 'When I enter my email address I am told to check my inbox' do
    recover_password
    expect(page).to have_content 'Please check your inbox for a recovery link'
  end

  scenario 'assigned a reset token to the user when they recover' do
    sign_up
    expect { recover_password }.to change {User.first.password_token}
  end

  scenario 'it asks for your new password when token is valid' do
    recover_password
    visit "/users/reset_password?token=#{user.password_token}"
    expect(page).to have_content 'Please enter your new password'
  end

  scenario 'it saves a possword recovery token time when we generate one' do
    Timecop.freeze do
      user.generate_token
      expect(user.password_token_time).to eq Time.now
    end
  end

  def recover_password
    visit '/users/recover'
    fill_in 'email', with: 'pjackson@iszombie.org'
    click_button('Reset password')
  end
end
