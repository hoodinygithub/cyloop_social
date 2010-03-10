class Admin::AccountsController < Admin::ApplicationController
  def slugs_for
    klass = params[:klass].constantize
  end
end