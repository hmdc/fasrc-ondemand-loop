module Zenodo::Handlers
  class Landing
    include LoggingCommon

    def initialize(object_id = nil)
      @object_id = object_id
    end

    def params_schema
      [
        :query,
        :page,
        :repo_url
      ]
    end

    def show(request_params)
      query = request_params[:query]
      page = request_params[:page]&.to_i || 1
      repo_url = request_params[:repo_url]
      log_info('Landing show', { repo_url: repo_url, query: query, page: page })
      results = nil

      if query.present?
        service = Zenodo::SearchService.new(repo_url.server_url)
        results = service.search(query, page: page)
        log_info('Search results', { query: query, page: page, results: results&.items&.size })
      end
      ConnectorResult.new(
        template: '/connectors/zenodo/landing/index',
        locals: { query: query, results: results, page: page, repo_url: repo_url },
        success: true
      )
    end
  end
end

