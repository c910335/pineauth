module ErrorHelper
  property! error : String

  private def error(type : Symbol)
    @error = {
      error:             type.to_s,
      error_description: "something went wrong.",
    }.to_json
  end

  private def error(body : String)
    @error = body
  end
end
