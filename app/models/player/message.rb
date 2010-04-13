# == Schema Information
#
# Table name: player_bases
#
#  code        :integer         default(200)
#  message     :string
#  description :string
#  code        :integer         default(200)
#  message     :string
#  description :string
#


class Player::Message < Player::Base

  column :code, :integer, 200
  column :message, :string
  column :description, :string

  def to_xml(options = {})
    options[:root] = 'message'
    super(options)
  end

end
