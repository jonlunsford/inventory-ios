schema "0001 initial" do
  entity "User" do
    string :email
    string :password
    string :password_confirmation

    has_many :companies, inverse: "Company.owner"
  end

  entity "Company" do
    string :title

    belongs_to  :owner, inverse: "User.companies"
    has_many    :categories
    has_one     :address, inverse: "Address.company"
  end

  entity "Category" do
    string :name

    belongs_to :company
    has_many :inputs
    has_many :products, plural_inverse: true
  end

  entity "Address" do
    string :city
    string :state
    string :country
    string :line1
    string :line2
    string :phone
    string :notes
    integer16 :zip
    decimal :lat
    decimal :long

    belongs_to :company, inverse: "Company.address"
    belongs_to :input, inverse: "Input.address"
  end

  entity "Input" do
    string :name
    string :label
    string :value
    string :input_type
    boolean :disabled, default: false

    belongs_to :category
    belongs_to :product
    has_one :address
    has_many :metas
  end

  entity "Meta" do
    string :key
    string :value

    belongs_to :input, inverse: "Input.metas"
  end

  entity "Product" do
    string :name

    has_many :inputs
    has_many :categories, plural_inverse: true
  end

end
