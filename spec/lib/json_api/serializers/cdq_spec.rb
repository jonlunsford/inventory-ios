describe 'JSONAPI::Serializers::CDQ' do

  before do
    class << self
      include CDQ
    end

    cdq.setup

  end

  after do
    cdq.reset!
  end

  it 'should add a serialize method' do
    address = Address.create(id: 1, city: "Springfield", state: "Oregon", country: "USA", zip: 666)

    address.serialize.should == {
      data: {
        type: "addresses",
        id: 1,
        attributes: {
          city: "Springfield",
          country: "USA",
          lat: 0.0,
          long: 0.0,
          state: "Oregon",
          zip: 666
        },
        relationships: {
          company: { data: nil },
          input: { data: nil }
        },
        links: {
          self: "http://localhost:4000/api/v1/addresses/1"
        }
      }
    }
  end

  it 'should serialize relationships' do
    address = Address.create(city: "SLO", id: 1)
    user = User.create(email: "test@test.com", id: 1)
    company = Company.create(id: 1, title: "With Address", address: address, owner: user)

    company.categories.create(name: "category a", id: 1)
    company.categories.create(name: "category b", id: 2)

    serialized = company.serialize[:data]
    serialized[:type].should == "companies"
    serialized[:id].should == 1
    serialized[:attributes].should == { title: "With Address" }
    serialized[:relationships][:address][:data].should == { type: "address", id: 1 }
    serialized[:relationships][:owner][:data].should == { type: "owner", id: 1 }
    serialized[:relationships][:categories][:data].count.should == 2
  end

  it 'should render to json' do
    meta = Meta.create(key: "My Key", value: "My Value")
    meta.to_json.should == '{"data":{"type":"meta","id":0,"attributes":{"key":"My Key","value":"My Value"},"relationships":{"input":{"data":null}},"links":{"self":"http:\\/\\/localhost:4000\\/api\\/v1\\/meta\\/0"}}}'
  end

  it 'should create from json' do
    json = '{"data":{"type":"meta", "id": 1,"attributes":{"key":"My Key","value":"My Value"},"relationships":{"input":{"data":null}}}}'
    meta = Meta.from_json(json)
    meta.id.should == 1
    meta.key.should == "My Key"
    meta.value.should == "My Value"
  end

end


