class CreateForm
  include ActiveModel::Model

  attr_accessor :name, :category_id, :price, :description, :screen, :camera, :cpu,
    :ram, :rom, :pin, :image_url

  validates :name, presence: true
  validates :price, presence: true,
    length: {maximum: Settings.product.validates.price_maximum},
    numericality: {only_integer: true, greater_than: 0}
  validates :screen, presence: true
  validates :camera, presence: true
  validates :cpu, presence: true
  validates :ram, presence: true
  validates :rom, presence: true
  validates :pin, presence: true
  validates :image_url, presence: true

  def register
    if valid?
      create_product
      create_feature
      create_image
    end
  end

  private
  def create_product
    hash = Hash.new
    hash[:name] = "#{name}"
    hash[:category_id] = "#{category_id}"
    hash[:price] = "#{price}"
    hash[:description] = "#{description}"
    @product ||= Product.new hash
    @product.save!
  end

  def create_feature
    hash = Hash.new
    hash[:screen] = "#{screen}"
    hash[:camera] = "#{camera}"
    hash[:cpu] = "#{cpu}"
    hash[:ram] = "#{ram}"
    hash[:rom] = "#{rom}"
    hash[:pin] = "#{pin}"
    @feature ||= Feature.new hash
    @feature.product = @product
    @feature.save!
  end

  def create_image
    hash = Hash.new
    hash[:image_url] = "#{image_url}"
    @image ||= Image.new hash
    @image.product = @product
    @image.save!
  end
end

