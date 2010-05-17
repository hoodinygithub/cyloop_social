module UsersHelper
  def possessive(object_key)
    if params[:slug]
      t("possessives.third_person.#{object_key.to_s}", :subject => artist_or_user_name(profile_account))
    else
      t("possessives.first_person.#{object_key.to_s}")
    end
  end
end

