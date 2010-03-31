class SearchesController < ApplicationController
  def show
    @active_scope=params[:scope]
    @counts=cross_count(params[:q])
    @active_scope = @counts.sort {|a,b| a[1]<=>b[1]}.last.first.downcase if params[:scope] == "any"
    @results=individual_search(params[:q],@active_scope, 20, ordering(@active_scope,params[:order]), sorting(@active_scope,params[:order]))
  end

  def autocomplete
    @results=cross_search(params[:q], per_page = 4)
    render :partial => 'searches/list', :object => @results, :locals => {:query => params[:q]}
  end

  private
    def individual_search (q, scope, per_page = 20, order = nil, sort = nil )
      @scope = scope.classify.constantize
      query="#{q}"
      query="#{q}*" if scope.downcase=="song" || scope.downcase=="album" || scope.downcase=="artist"
      if order.nil?
        results = @scope.search(query, :page => params[:page], :per_page => per_page)
        logger.info "SPHINX ******** No sort *****#{scope} = #{query}"
      else
        results = @scope.search(query, :page => params[:page], :per_page => per_page,:order=> order, :sort_mode=>sort)
        logger.info "SPHINX ******** SORT *****#{scope} =  #{query} =  #{order} = #{sort}"
      end
      results
    end

    def cross_search (q, per_page = 20)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}"
        query="#{q}*" if scope.downcase=="song" || scope.downcase=="album" || scope.downcase=="artist"
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

    def ordering(scope,sort)
      result=nil
      case scope
      when 'artist'
        result=:name if sort=='alpha'
        result=:visit_count if sort=='rel' || sort.blank?
      when 'station'
        result=:name if sort=='alpha'
        result=:created_at if sort=='rel' || sort.blank?
      when 'album'
        result=:name if sort=='alpha'
        result=:year if sort=='rel' || sort.blank?
      when 'user'
        result=:name if sort=='alpha'
        result=:visit_count if sort=='rel' || sort.blank?
      end
      result
    end

    def sorting(scope,sort)
      result=nil
      case scope
      when 'artist' || 'user'
        result=:desc if sort=='rel' || sort.blank?
        result=:asc if sort=='alpha'
      when 'station'
        result=:asc if sort=='alpha'
        result=:desc if sort=='rel' || sort.blank?
      when 'album'
        result=:asc if sort=='alpha'
        result=:desc if sort=='rel' || sort.blank?
      when 'user'
        result=:desc if sort=='rel' || sort.blank?
        result=:asc if sort=='alpha'
      end
      result
    end

  private
    def cross_search (q, per_page = 10)
      results={}
      ["User","Station", "Album", "Artist" ].each do |scope|
        @scope = scope.classify.constantize
        query="#{q}"
        query="#{q}*" if scope=="Song" || scope=="Album"
        partial_results = @scope.search query, :page => params[:page], :per_page => per_page
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

end

