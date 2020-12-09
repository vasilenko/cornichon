class LinksController < ApplicationController
  def create
    creator = LinkCreator.new(params[:url])
    link = creator.call

    render json: { slug: link.slug }, status: 201
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
