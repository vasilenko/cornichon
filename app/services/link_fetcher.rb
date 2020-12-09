class LinkFetcher
  def initialize(slug)
    @slug = slug
  end

  def call
    Link.find_by!(slug: @slug)
        .tap { |link| link.increment!(:visit_count) }
  end
end
