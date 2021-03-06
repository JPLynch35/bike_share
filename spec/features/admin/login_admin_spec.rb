require 'rails_helper'

describe 'an admin user' do
  it 'should land on /admin/dashboard after login,
      and see their name in navbar and profile information' do
    admin = User.create(first_name: 'pearl',
                         last_name: 'girl',
                         street: '9th ave',
                         city: 'denver',
                         state: 'CO',
                         zip_code: '12345',
                         email: 'pearl@pearl.com',
                         password: 'lovelove',
                         role: 1 )

    visit login_path

    within('nav') do
      expect(page).to_not have_content('Login')
    end

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password

    expect(admin.role).to eq('admin')
    expect(admin.admin?).to eq(true)

    within('#existing-user-login') do
      click_on 'Login'
    end

    expect(current_path).to eq(admin_dashboard_path)

    within('#admin-nav') do
      expect(page).to have_content("Administrator Logged in as: #{admin.first_name}")
    end

    expect(page).to have_content(admin.first_name)
    expect(page).to have_content(admin.street)
    expect(page).to have_content(admin.city.capitalize)
    expect(page).to have_content(admin.state)
    expect(page).to have_content(admin.zip_code)
    expect(page).to have_content(admin.email)

    expect(page).to have_content('Logout')
    expect(page).to_not have_content('Login')
  end
end

describe 'default user' do
  it 'should not be able to see admin dashboard page' do
    user = User.create( first_name: 'barry',
                         last_name: 'b',
                         street: '9th ave',
                         city: 'denver',
                         state: 'CO',
                         zip_code: '12345',
                         email: 'barry@barry.com',
                         password: 'barrybarry',
                         role: 0 )
   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

   visit admin_dashboard_path

   within('#admin-nav') do
     expect(page).to_not have_content("Administrator Logged in as: #{user.first_name}")
   end

   expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
