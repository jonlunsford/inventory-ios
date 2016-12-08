describe 'Session' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Session entity' do
    Session.entity_description.name.should == 'Session'
  end

  it 'should have a token' do
    Session.create(token: "1234").token.should == "1234"
  end
end
