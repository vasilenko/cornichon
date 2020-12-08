class LinkCreator
  SLUG_LENGTH = 6
  SLUG_RETRY_LIMIT = 100

  private_constant :SLUG_LENGTH
  private_constant :SLUG_RETRY_LIMIT

  def initialize(url)
    @url = url
  end

  def call
    retry_count ||= 0
    insert_link
  rescue ActiveRecord::RecordNotUnique
    retry if (retry_count += 1) < SLUG_RETRY_LIMIT
  end

  private

  def insert_link
    result, = Link.insert(insert_attributes, returning: %w[slug], unique_by: :url)
    result ? result['slug'] : Link.find_by(url: @url).slug
  end

  def insert_attributes
    {
      url: @url,
      slug: slug
    }
  end

  def slug
    rand(36**SLUG_LENGTH).to_s(36)
  end
end
