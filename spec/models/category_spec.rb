describe 'Category' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Category entity' do
    Category.entity_description.name.should == 'Category'
  end

  it 'should have a name' do
    Category.create(name: "name").name.should == "name"
  end

  it 'should belong to a company' do
    company = Company.create(title: "title")
    category = Category.create(name: "category", company: company)

    category.company.title.should == "title"
  end

  it 'should have many inputs' do
    category = Category.create(name: "with inputs")
    category.inputs.create(name: "input a")
    category.inputs.create(name: "input b")

    category.inputs.count.should == 2
  end

  it 'should have many products' do
    category = Category.create(name: "with products")
    category.products.create(name: "product a")
    category.products.create(name: "product b")

    category.products.count.should == 2
  end
end
