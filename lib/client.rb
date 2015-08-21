class Client
  attr_reader(:client_name, :client_id)

  define_method(:initialize) do |attributes|
    @client_name = attributes.fetch(:client_name)
    @client_id = attributes.fetch(:client_id, nil)
  end

  define_singleton_method(:all) do
    result = DB.exec("SELECT * FROM clients;")
    clients = []
    result.each() do |client|
      client_name = client.fetch("client_name")
      client_id = client.fetch("client_id").to_i()
      clients.push(Client.new({:client_name => client_name, :client_id => client_id}))
    end
    clients
  end


  define_method(:==) do |another_client|
    self.client_id == another_client.client_id
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO clients (client_name) VALUES ('#{@client_name}') RETURNING client_id;")
    @client_id = result.first().fetch('client_id').to_i()
  end

  define_singleton_method(:find) do |id|
    found_client = nil
    Client.all().each() do |client|
      if client.client_id() == id
        found_client = client
      end
    end
    found_client
  end

  define_singleton_method(:find_by_client_name) do |client_name_to_find|
    found_client = nil
    Client.all().each() do |client|
      if client.client_name() == client_name_to_find
        found_client = client
      end
    end
    found_client
  end

  define_method(:update) do |attributes|
    @client_name = attributes.fetch(:client_name, @client_name)
    @id = self.client_id()
    DB.exec("UPDATE clients SET client_name = '#{@client_name}' WHERE client_id = #{@id};")

    attributes.fetch(:stylist_ids, []).each() do |stylist_id|
      @check_out_date = Time.now()
      @due_date = Time.now + (60*60*24*7*2)
      DB.exec("INSERT INTO clients_stylists (client_id, stylist_id, check_out_date, due_date) VALUES (#{self.client_id}, #{stylist_id}, '#{@check_out_date}', '#{@due_date}');")
    end
  end

  define_method(:delete) do
    @id = self.client_id()
    DB.exec("DELETE FROM clients WHERE client_id = #{@id};")
  end

  define_method(:stylists) do
    returned_stylists = []
    results = DB.exec("SELECT * FROM clients_stylists WHERE client_id = #{(self.client_id)};")

    results.each() do |result|
      stylist_id = result.fetch('stylist_id').to_i()
      stylist = DB.exec("SELECT * FROM stylists WHERE stylist_id = #{stylist_id};")
      name = stylist.first().fetch('stylist_name')
      returned_stylists.push(Stylist.new({:stylist_name => name, :stylist_id => stylist_id}))
    end
    returned_stylists
  end

  define_method(:checkout) do
    checkout = []
    results = DB.exec("SELECT * FROM clients_stylists WHERE client_id = #{self.client_id};")
    results.each() do |result|
      stylist_id = result.fetch('stylist_id').to_i()
      checked_out = result.fetch('check_out_date')
      due_date = result.fetch('due_date')
      returned = result.fetch('returned_date')
      checkout.push({:client_id => self.client_id, :stylist_id => stylist_id, :checked_out_date => checked_out, :due_date => due_date, :returned_date => returned})
    end
    checkout
  end

  define_method(:available?) do
    available = true
    checkout().each() do |instance|
      if instance.fetch(:client_id) == self.client_id && instance.fetch(:returned_date) == nil
        available = false
      end
    end
    available
  end

  define_method(:who_has_clients?) do
    stylist = nil
    checkout().each() do |instance|
      if instance.fetch(:client_id) == self.client_id && instance.fetch(:returned_date) == nil
        stylist = Stylist.find(instance.fetch(:stylist_id))
      end
    end
    stylist
  end

  define_method(:return_list) do
    return_list = []
    checkout().each() do |instance|
      return_list.push([instance.fetch(:stylist_id), instance.fetch(:returned_date), instance.fetch(:due_date)])
    end
    return_list
  end

  define_singleton_method(:search_for_client) do |input|
    results = DB.exec("SELECT * FROM clients where client_name LIKE '#{input}%';")
    clients = []
    results.each() do |client|
      client_name = client.fetch("client_name")
      client_id = client.fetch("client_id").to_i()
      clients.push(Client.new({:client_name => client_name, :client_id => client_id}))
    end
    clients
  end
end
