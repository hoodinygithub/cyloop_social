# == Schema Information
#
# Table name: player_bases
#
#  code        :integer
#  error       :string
#  description :string
#  code        :integer
#  error       :string
#  description :string
#


class Player::Error < Player::Base

  column :code, :integer
  column :error, :string
  column :description, :string

  def to_xml(options = {})
    options[:root] = 'error'
    super(options)
  end

end
