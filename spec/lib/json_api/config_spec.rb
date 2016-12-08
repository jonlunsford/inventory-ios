describe "JSONAPI::Config" do
  before do
    @double = Dummy.new
  end

  it 'should include a namespace' do
    @double.namespace.should == "api/v1"
  end

  it 'should include a resource url' do
    @double.resource_url.should == "http://localhost:4000/api/v1/dummies"
  end

  it 'should include a base url' do
    @double.base_url.should == "http://localhost:4000/api/v1"
  end

end

class Dummy
  include JSONAPI::Config

  def className
    "Dummy"
  end
end
