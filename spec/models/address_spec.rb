describe 'Address' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Address entity' do
    Address.entity_description.name.should == 'Address'
  end

  it 'should have a city' do
    Address.create(city: "City").city.should == "City"
  end

  it 'should have a state' do
    Address.create(state: "State").state.should == "State"
  end

  it 'should have a country' do
    Address.create(country: "country").country.should == "country"
  end

  it 'should have a line1' do
    Address.create(line1: "line1").line1.should == "line1"
  end

  it 'should have a line2' do
    Address.create(line2: "line2").line2.should == "line2"
  end

  it 'should have a phone' do
    Address.create(phone: "phone").phone.should == "phone"
  end

  it 'should have notes' do
    Address.create(notes: "notes").notes.should == "notes"
  end

  it 'should have a zip' do
    Address.create(zip: 666).zip.should == 666
  end

  it 'should have a lat' do
    Address.create(lat: 10.384).lat.should == 10.384
  end

  it 'should have a long' do
    Address.create(long: 10.384).long.should == 10.384
  end

  it 'should belong to a company' do
    address = Address.create(city: "city")
    company = Company.create(title: "With Address", address: address)
    company.address.city.should == "city"
  end
end
