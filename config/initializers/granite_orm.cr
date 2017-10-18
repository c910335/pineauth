class Granite::ORM::Base
  macro inherited
    @@includes_blocks : Hash(Symbol, Proc(Array({{@type}}), Nil)) = Hash(Symbol, Proc(Array({{@type}}), Nil)).new
  end

  macro belongs_to!(name)
    {% klass = name.id.capitalize %}

    field {{name.id}}_id : Int64
    @{{name.id}} : {{klass}}?

    def {{name.id}}?
      @{{name.id}} ||= {{klass}}.find({{name.id}}_id)
    end

    def {{name.id}}
      {{name.id}}?.not_nil!
    end

    def {{name.id}}=(parent)
      @{{name.id}}_id = parent.id
      @{{name.id}} = parent
    end

    @@includes_blocks[:{{name.id}}s] = -> (children : Array({{@type}})) {
      parents = {{klass}}.where(id: children.map(&.{{name.id}}_id))
      parents_map = Hash(Int64 | Nil, {{klass}}).new
      parents.each do |parent|
        parents_map[parent.id] = parent
      end
      children.each do |child|
        child.{{name.id}} = parents_map[child.{{name.id}}_id]
      end
      nil
    }
  end

  macro has_many!(name, id = nil)
    {% klass = name.id[0...-1].camelcase %}
    {% table_name = SETTINGS[:table_name] || @type.name.gsub(/::/, "_").downcase.id + "s" %}
    {% parent_id = id || table_name[0...-1] + "_id" %}

    @{{name.id}} : Array({{klass}})?

    def {{name.id}}
      return @{{name.id}}.not_nil! unless @{{name.id}}.nil?
      return [] of {{klass}} unless id
      foreign_key = "{{name.id}}.{{parent_id}}"
      query = "WHERE #{foreign_key} = ?"
      @{{name.id}} = {{klass}}.all(query, id)
    end

    def {{name.id}}=(children)
      @{{name.id}} = children
    end

    @@includes_blocks[:{{name.id}}] = -> (parents : Array({{@type}})) {
      children = {{klass}}.where({{parent_id}}: parents.map(&.id))
      parents_map = Hash(Int64 | Nil, {{@type}}).new
      parents.each do |parent|
        parent.{{name.id}} = [] of {{klass}}
        parents_map[parent.id] = parent
      end
      children.each do |child|
        parents_map[child.{{parent_id}}].{{name.id}} << child
      end
      nil
    }
  end

  def self.where(**conditions)
    conditions = conditions.to_h
    includes = conditions.delete(:includes)
    limit = conditions.delete(:limit)
    params = [] of DB::Any
    clause = String.build do |s|
      s << "WHERE "
      i = 0
      s << conditions.map do |k, v|
        if v
          if v.is_a?(Array)
            "#{k} IN (#{v.join(",")})"
          elsif v.is_a?(DB::Any)
            params << v
            "#{k} = $#{i += 1}"
          end
        else
          "#{k} IS NULL"
        end
      end.join(" AND ")
      s << " LIMIT #{limit}" if limit
    end
    results = all(clause, params)
    if includes
      @@includes_blocks[includes]?.try &.call results
    end
    results
  end

  def self.find_by(**conditions)
    results = where(**conditions, limit: 1)
    if results.empty?
      nil
    else
      results.first
    end
  end
end
