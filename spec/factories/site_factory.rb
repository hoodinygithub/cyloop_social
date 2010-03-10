Factory.define :cyloop_login_type, :class => LoginType do |factory|
  factory.name "cyloop"
end

Factory.define :wlid_login_type, :class => LoginType do |factory|
  factory.name "wlid_web"
end

Factory.define :cyloop_site, :class => Site do |factory|
  factory.name "Cyloop"
  factory.default_locale :en
  factory.code "cyloop"
  factory.association :login_type, :factory => :cyloop_login_type
end

Factory.define :msnmx_site, :class => Site do |factory|
  factory.name "MSN Mexico"
  factory.default_locale :es
  factory.code "msncaen"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msnbr_site, :class => Site do |factory|
  factory.name "MSN Brazil"
  factory.default_locale :pt_BR
  factory.code "msnbr"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msnlatam_site, :class => Site do |factory|
  factory.name "MSN Latam"
  factory.default_locale :es
  factory.code "msnlatam"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msnargentina_site, :class => Site do |factory|
  factory.name "MSN Argentina"
  factory.default_locale :es
  factory.code "msnar"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msnlatino_site, :class => Site do |factory|
  factory.name "MSN US Latin"
  factory.default_locale :es
  factory.code "msnlatino"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msncaen_site, :class => Site do |factory|
  factory.name "MSN Canada EN"
  factory.default_locale :en_CA
  factory.code "msncaen"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :msncafr_site, :class => Site do |factory|
  factory.name "MSN Canada FR"
  factory.default_locale :fr_CA
  factory.code "msncafr"
  factory.association :login_type, :factory => :wlid_login_type
end

Factory.define :cyloopes_site, :class => Site do |factory|
  factory.name "Cyloop ES"
  factory.default_locale :es
  factory.code "cyloopes"
  factory.association :login_type, :factory => :wlid_login_type
end