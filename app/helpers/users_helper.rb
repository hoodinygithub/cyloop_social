module UsersHelper
  def possessive(object_key)
    if params[:slug]
      t("possessives.third_person.#{object_key.to_s}", :subject => profile_account.first_name)
    else
      t("possessives.first_person.#{object_key.to_s}")
    end
  end
end

