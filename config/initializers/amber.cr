class Amber::Validators::Params
  def to_h
    if @params.empty?
      raw_params.to_h
    else
      @params
    end
  end
end
