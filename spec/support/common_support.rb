module CommonSupport

  def parse_response_body(response)
    b = response.body
    ActiveSupport::JSON.decode(b)
  end

end