describe 'Company' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Company entity' do
    Company.entity_description.name.should == 'Company'
  end

  it 'should have a title' do
    Company.create(title: "My Title").title.should == "My Title"
  end

  it 'should belong to an owner' do
    user = User.create(email: "test@test.com", password: "asdf1234", password_confirmation: "asdf1234")
    company = Company.create(owner: user, title: "With User")
    company.owner.email.should == "test@test.com"
  end

  it 'should have many categories' do
    company = Company.create(title: "With Category")
    company.categories.create(name: "Kegs")
    company.categories.first.name.should == "Kegs"
  end

  it 'should have one address' do
    address = Address.create({
      city: "Springfield",
      state: "Oregon",
      country: "USA",
      zip: 666666,
      lat: 10.000039,
      long: 9.00893,
      line1: "1234 Evergreen Terrace",
      line2: "Nowhere",
      phone: "666 666 6666",
      notes: "Notes about address"
    })

    company = Company.create(title: "With Address", address: address)
    company.address.country.should == "USA"
  end
end
