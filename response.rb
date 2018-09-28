module Response
  def json_response(object, status = :ok)
    pretty_json = JSON.pretty_generate(JSON.parse(object.to_json))
    render json: pretty_json, status: status
  end
end
  