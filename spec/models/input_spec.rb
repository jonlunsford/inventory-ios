describe 'Input' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Input entity' do
    Input.entity_description.name.should == 'Input'
  end

  it 'should have a name' do
    Input.create(name: "name").name.should == "name"
  end

  it 'should have a label' do
    Input.create(label: "label").label.should == "label"
  end

  it 'should have a value' do
    Input.create(value: "value").value.should == "value"
  end

  it 'should have a input_type' do
    Input.create(input_type: "input_type").input_type.should == "input_type"
  end

  it 'should indicate disabled' do
    Input.create(disabled: true).disabled.should == 1
  end

  it 'should have many metas' do
    input = Input.create(name: "with metas")
    input.metas.create(key: "key a", value: "value a")
    input.metas.create(key: "key b", value: "value b")

    input.metas.count.should == 2
  end

  it 'should have one address' do
    address = Address.create(city: "city")
    input = Input.create(name: "with address", address: address)

    input.address.city.should == "city"
  end
end
