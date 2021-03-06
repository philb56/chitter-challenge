feature 'User sign up' do

  scenario 'creates user if matching confirmation password' do
    expect { sign_up }.to change(User, :count)
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario 'can\'t create user if email blank' do
    expect { sign_up(email: nil) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email must not be blank')
  end

  scenario 'can\'t create user if email invalid' do
    expect { sign_up(email: 'invalidEmailAddress') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has an invalid format')
  end

  scenario 'can\'t create user user already exists' do
    sign_up
    expect { sign_up }.not_to change(User, :count)
    expect(page).to have_content("Email is already taken")
  end

end

feature 'User sign in' do

  let!(:user) do
    User.create(email: 'user@example.com',
                name: 'Bob',
                username: '@Bob',
                password: 'secret1234',
                password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials' do
    sign_in(email: user.email,   password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end
end
