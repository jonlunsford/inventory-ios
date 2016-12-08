describe 'Product' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Product entity' do
    Product.entity_description.name.should == 'Product'
  end

  it 'should have a name' do
    Product.create(name: "name").name.should == "name"
  end

  it 'should have many inputs' do
    product = Product.create(name: "with inputs")
    product.inputs.create(name: "input a")
    product.inputs.create(name: "input b")

    product.inputs.count.should == 2
  end

  it 'should have many categories' do
    product = Product.create(name: "with inputs")
    product.categories.create(name: "category a")
    product.categories.create(name: "category b")

    product.categories.count.should == 2
  end
end
