describe 'User' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a User entity' do
    User.entity_description.name.should == 'User'
  end

  it 'should have an email' do
    User.create(email: "test@test.com").email.should == "test@test.com"
  end

  it 'should have a password' do
    User.create(password: "password").password.should == "password"
  end

  it 'should have a password_confirmation' do
    User.create(password_confirmation: "password_confirmation").password_confirmation.should == "password_confirmation"
  end

  it 'should have many companies' do
    user = User.create(email: "test@test.com")
    user.companies.create(title: "company a")
    user.companies.create(title: "company b")

    user.companies.count.should == 2
  end
end
