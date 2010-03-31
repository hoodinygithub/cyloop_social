class SearchesController < ApplicationController
  def show
    @active_scope=params[:scope]
    @counts=cross_count (params[:q])
    @active_scope = @counts.sort {|a,b| a[1]<=>b[1]}.last.first.downcase if params[:scope] == "any"
    unless ordering(@active_scope,params[:order])
      @results=individual_search(params[:q],@active_scope, 20, sorting(@active_scope,params[:order]))
    else
      @results=individual_search(params[:q],@active_scope, 20, sorting(@active_scope,params[:order]), ordering(@active_scope,params[:order]))
    end
  end

  def autocomplete
    @results=cross_search (params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def individual_search (q, scope, per_page = 20, order = nil, sort = nil )
      @scope = scope.classify.constantize
      query="#{q}"
      query="#{q}*" if scope.downcase=="song" || scope.downcase=="album"
      if order.nil?
        results = @scope.search(query, :page => params[:page], :per_page => per_page)
      else
        unless sort.nil?
          results = @scope.search(query, :page => params[:page], :per_page => per_page,:order=> order, :sort_mode=>sort)
        else
          results = @scope.search(query, :page => params[:page], :per_page => per_page,:order=> order)
        end
      end
      results
    end

    def cross_search (q, per_page = 20)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}"
        query="#{q}*" if scope=="Song" || scope=="Album"
        partial_results = @scope.search query, :per_page => per_page
        results.store(scope,partial_results)
      end
      #@cross_search=ThinkingSphinx::Search.search "#{params[:q]}" , :classes => [User, Song, Album, Artist ]
      results
    end

    def cross_count (q)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}*"
        partial_results = @scope.search_count query
        results.store(scope,partial_results)
      end
      #@cross_search=ThinkingSphinx::Search.search "#{params[:q]}" , :classes => [User, Song, Album, Artist ]
      results
    end

    def sorting(scope,sort)
      result=nil
      case scope
      when 'artist'
        result=:name if sort=='alpha'
        result=:visit_count if sort=='rel' || sort.blank?
      when 'station'
        result=nil if sort=='alpha'
      end
      result
    end

    def ordering(scope,sort)
      result=nil
      case scope
      when 'artist'
        result=:desc if sort=='rel' || sort.blank?
      end
      result
    end

end

