class Stylist
  attr_reader(:stylist_name, :stylist_id)

  define_method(:initialize) do |attributes|
    @stylist_name = attributes.fetch(:stylist_name)
    @stylist_id = attributes.fetch(:stylist_id, nil)
  end

  define_singleton_method(:all) do
    result = DB.exec("SELECT * FROM stylists;")
    stylists = []
    result.each() do |stylist|
      name = stylist.fetch("stylist_name")
      stylist_id = stylist.fetch("stylist_id").to_i()
      stylists.push(Stylist.new({:stylist_name => name, :stylist_id => stylist_id}))
    end
    stylists
  end

  define_method(:==) do |another_stylist|
    self.stylist_id == another_stylist.stylist_id
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO stylists (stylist_name) VALUES ('#{@stylist_name}') RETURNING stylist_id;")
    @stylist_id = result.first().fetch('stylist_id').to_i()
  end

  define_singleton_method(:find) do |id|
    Stylist.all().each() do |stylist|
      if stylist.stylist_id() == id
        return stylist
      end
    end
  end

  define_method(:update) do |attributes|
    @stylist_name = attributes.fetch(:stylist_name, @stylist_name)
    @id = self.stylist_id()
    DB.exec("UPDATE stylists SET stylist_name = '#{@stylist_name}' WHERE stylist_id = #{@id};")

    attributes.fetch(:client_ids, []).each() do |client_id|
      @check_out_date = Time.now()
      @due_date = Time.now + (60*60*24*7*2)
      DB.exec("INSERT INTO clients_stylists (client_id, stylist_id, check_out_date, due_date, returned_date) VALUES (#{client_id}, #{self.stylist_id()}, '#{@check_out_date}', '#{@due_date}', NULL);")
    end

    attributes.fetch(:returned_client_ids, []).each() do |client_id|
      @returned_date = Time.now
      DB.exec("UPDATE clients_stylists SET returned_date = '#{@returned_date}', due_date = NULL WHERE client_id = #{client_id};")
    end
  end

  define_method(:delete) do
    @id = self.stylist_id()
    DB.exec("DELETE FROM stylists WHERE stylist_id = #{@id}")
  end

  define_method(:checkout) do
    checkout = []
    results = DB.exec("SELECT * FROM clients_stylists WHERE stylist_id = #{self.stylist_id()};")
    results.each() do |result|
      client_id = result.fetch('client_id').to_i()
      checked_out = result.fetch('check_out_date')
      due_date = result.fetch('due_date')
      returned = result.fetch('returned_date')
      checkout.push({:client_id => client_id, :stylist_id => self.stylist_id, :checked_out_date => checked_out, :due_date => due_date, :returned_date => returned})
    end
    checkout
  end

  define_method(:clients) do
    clients = []
    checkout().each() do |client|
      clients.push(Client.find(client.fetch(:client_id)))
    end
    clients
  end
end
