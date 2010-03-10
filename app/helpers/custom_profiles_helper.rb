
module CustomProfilesHelper

  def paginate_top_100_songs
    page = (params[:page] || 1).to_i
    page = 1 if page < 1 || page > 10

    top_songs = current_site.summary_top_songs.paginate(
      :page => page,
      :per_page => 10,
      :include => { :song => [ :album, :artist ] },
      :joins => :song,
      :conditions => 'songs.deleted_at IS NULL' )

    top_song = if page == 1
      top_songs.first
    else
      current_site.summary_top_songs.first(
        :joins => :song,
        :conditions => 'songs.deleted_at IS NULL'
      )
    end

    return top_songs, top_song.total_listens.to_f
  end

end