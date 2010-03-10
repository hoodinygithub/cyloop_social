Factory.define :genre do |factory|
  factory.name "Poopoo"
  factory.parent_id {rand(10) * 999999999}
end
