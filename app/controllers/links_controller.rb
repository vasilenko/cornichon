class LinksController < ApplicationController
  def create
    creator = LinkCreator.new(params[:url])
    link = creator.call

    if link
      render json: { slug: link.slug }, status: 201
    else
      render json: { error: 'URL is invalid' }, status: 422
    end
  end

  def show
    fetcher = LinkFetcher.new(params[:slug])
    link = fetcher.call

    render json: { url: link.url }
  end

  def stats
    link = Link.find_by!(slug: params[:slug])

    render json: { visit_count: link.visit_count }
  end
end
