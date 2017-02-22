describe 'User' do

  def parse_request_errors(http_result)
    info = http_result.error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
    errors = BW::JSON.parse(info)['errors']
    errors ? errors.map { |e| e['detail'] } : []
  end

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    User.all.each { |u| u.destroy }
    cdq.reset!
  end

  it 'should be a User entity' do
    User.entity_description.name.should == 'User'
  end

  it 'should have an email' do
    User.create(email: 'test@test.com').email.should == 'test@test.com'
  end

  it 'should have a password' do
    User.create(password: 'password').password.should == 'password'
  end

  it 'should have a password_confirmation' do
    User.create(password_confirmation: 'password_confirmation').password_confirmation.should == 'password_confirmation'
  end

  it 'should have many companies' do
    user = User.create(email: 'test@test.com')
    user.companies.create(title: 'company a')
    user.companies.create(title: 'company b')

    user.companies.count.should == 2
  end

  context 'with api' do

    it 'should parse registration errors' do
      user_a = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
      user_a.register

      user_b = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
      user_b.register

      user_b.register do |result|
        @errors = parse_request_errors(result)
      end

      wait 1 do
        @errors.first.should == "Email has already been taken"
      end
    end

    it 'should log in' do
      user = User.create(email: 'test@test.com', password: 'asdf1234', password_confirmation: 'asdf1234')
      user.log_in

      wait 1 do
        user.session.should.not.be.nil?
      end
    end

    #it "deletes from the api" do
      #user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
      #user.destroy!
      #user.should.be.nil
    #end
  end
end
