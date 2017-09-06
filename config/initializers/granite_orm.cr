class Granite::ORM

  macro belongs_to(name)
    @{{name.id}} : {{name.id.capitalize}}?

    def {{name.id}}?
      @{{name.id}} ||= {{name.id.capitalize}}.find({{name.id}}_id)
    end

    def {{name.id}}
      {{name.id}}?.not_nil!
    end
  end

  def self.where(**conditions)
    params = [] of DB::Any
    clause = String.build do |s|
      s << "WHERE "
      i = 0
      s << conditions.map do |k, v|
        if v
          params << v
          "#{k} = $#{i += 1}"
        else
          "#{k} IS NULL"
        end
      end.join(" AND ")
    end
    all(clause, params)
  end

  def self.find_by(**conditions)
    params = [] of DB::Any
    clause = String.build do |s|
      s << "WHERE "
      i = 0
      s << conditions.map do |k, v|
        if v
          params << v
          "#{k} = $#{i += 1}"
        else
          "#{k} IS NULL"
        end
      end.join(" AND ")
      s << " LIMIT 1"
    end
    all(clause, params).first
  end
end
