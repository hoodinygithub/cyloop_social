module SiteHelper
  def load_sites
    # Truncate login_types and sites to that we always start with empty database.
    ActiveRecord::Base.connection.execute("TRUNCATE login_types")
    ActiveRecord::Base.connection.execute("TRUNCATE sites")
    Factory(:cyloop_site)
    Factory(:msnmx_site)
    Factory(:msnbr_site)
    Factory(:msnlatam_site)
    Factory(:msnlatino_site)
    Factory(:msncaen_site)
    Factory(:msncafr_site)
    Factory(:cyloopes_site)
  end
end