describe 'RegistrationScreen' do
  tests RegistrationScreen

  before do
    @controller = RegistrationScreen.new
  end

  after do
    @controller = nil
  end

  it 'has the right screen header' do
    view('Inventory IO').should.be.kind_of(UILabel)
  end

  it 'has an email field' do
    view('Email').should.be.kind_of(UITextField)
  end

  it 'has an password field' do
    view('Password').should.be.kind_of(UITextField)
  end

  it 'has an password confirmation field' do
    view('Password Confirmation').should.be.kind_of(UITextField)
  end

  it "has link to log in screen" do
    view('Already have an account? Log In.').should.be.kind_of(UILabel)
  end
end
