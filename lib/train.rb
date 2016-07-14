class Train
  attr_reader(:id, :name)

  define_method(:initialize) do |attributes|
    @id = attributes[:id] || nil
    @name = attributes.fetch(:name)
  end

  define_singleton_method (:all) do
    all_trains = DB.exec("SELECT * FROM trains;")
    trains = []
    all_trains.each() do |train|
      name = train.fetch("name")
      id = train.fetch("id").to_i()
      trains.push(Train.new({:id => id,:name => name}))
    end
    trains
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO trains (name) VALUES ('#{@name}') RETURNING id;")
    @id  =  result.first().fetch("id").to_i()
  end

  define_method(:==) do |other_train|
    self.id() == other_train.id()
  end

  define_singleton_method(:find) do |id|
    # train_found
    Train.all().each() do |train|
      if train.id() == id
        return train
      end
    end
  end

  define_method(:update) do |attributes|
    @id = self.id()
    @name = attributes.fetch(:name)
    DB.exec("UPDATE trains SET name = '#{@name}' WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM trains WHERE id = #{self.id()};")
  end

  define_method(:cities) do
    cities_list = DB.exec("SELECT * FROM cities JOIN cities_trains ON cities_trains.id = city_id WHERE train_id = #{self.id()};")
     cities = []

    cities_list.each() do city
      cities.push(City.new({:id => city.fetch("id"), :name => city.fetch("name")}))
    end
    cities
  end

end
