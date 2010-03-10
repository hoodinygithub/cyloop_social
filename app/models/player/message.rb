
class Player::Message < Player::Base

  column :code, :integer, 200
  column :message, :string
  column :description, :string

  def to_xml(options = {})
    options[:root] = 'message'
    super(options)
  end

end