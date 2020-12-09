module RequestHelpers
  module Json
    def response_body
      @response_body = nil if @reponse_object_id != response.object_id

      @reponse_object_id = response.object_id
      @response_body ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end

RSpec.configure do |config|
  config.include RequestHelpers::Json
end
