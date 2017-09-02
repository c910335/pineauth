class Granite::ORM
  def self.where(**conditions)
    params = [] of DB::Any
    clause = String.build do |s|
      s << "WHERE "
      i = 0
      s << conditions.map do |k, v|
        if v
          params << v
          "#{k} $#{i += 1}"
        else
          "#{k} NULL"
        end
      end.join(" and ")
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
          "#{k} $#{i += 1}"
        else
          "#{k} NULL"
        end
      end.join(" and ")
      s << " LIMIT 1"
    end
    all(clause, params).first
  end
end
