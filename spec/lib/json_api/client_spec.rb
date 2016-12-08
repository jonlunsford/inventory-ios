describe "JSONAPI::Client" do
  before do
    class << self
      include CDQ
    end
    cdq.setup

    @namespace = "api/v1"
    @base_url = "http://localhost:4000"
    @session = Session.create(token: "asdf")
    @client = JSONAPI::Client.new(@base_url)
  end

  after do
    cdq.reset!
  end

  it "can be configured with a base_url" do
    @client.base_url.should == @base_url
  end

  it "should have a default namespace" do
    @client.namespace.should == "api/v1"
  end

  it "should return errors" do
    @errors = nil

    @client.get("user") do |response, errors|
      @errors = errors
      resume
    end

    wait_max 20 do
      @errors.first.fetch("code").should == 401
    end
  end

end
