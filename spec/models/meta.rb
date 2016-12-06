describe 'Meta' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Meta entity' do
    Meta.entity_description.name.should == 'Meta'
  end

  it 'should have a key' do
    Meta.create(key: "key").key.should == "key"
  end

  it 'should have a value' do
    Meta.create(value: "value").value.should == "value"
  end
end
