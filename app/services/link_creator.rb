class LinkCreator
  Error = Class.new(StandardError)

  SLUG_LENGTH = 6
  SLUG_RETRY_LIMIT = 100

  private_constant :SLUG_LENGTH
  private_constant :SLUG_RETRY_LIMIT

  def initialize(url)
    @url = url
  end

  def call
    retry_count ||= 0

    Link.insert(insert_attributes, returning: [], unique_by: :url)
    Link.find_by(url: @url)
  rescue ActiveRecord::RecordNotUnique
    retry if (retry_count += 1) < SLUG_RETRY_LIMIT

    raise Error, 'Unable to insert link with generated slug'
  end

  private

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
