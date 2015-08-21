require('spec_helper')

describe(Client) do
  describe('#client_name') do
    it("return the name of the client") do
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      expect(test_client.client_name()).to(eq('Samwell Tarley'))
    end
  end

  describe('.all') do
    it('return an empty array at first') do
      expect(Client.all()).to(eq([]))
    end
  end

  describe('#==') do
    it('returns equal when two clients have the same id') do
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client2 = Client.new({:client_name => 'Samwell Tarley'})
      expect(test_client).to(eq(test_client2))
    end
  end

  describe('#save') do
    it('saves an instance of client to the database') do
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client.save()
      expect(Client.all()).to(eq([test_client]))
    end
  end

  describe('.find') do
    it('return a client that matches the id') do
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client.save()
      expect(Client.find(test_client.client_id)).to(eq(test_client))
    end
  end

  describe('#update') do
    it('lets you add a stylist to a client') do
      test_stylist = Stylist.new({:stylist_name => 'Jon Snow'})
      test_stylist.save()
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client.save()
      test_client.update({:stylist_ids => [test_stylist.stylist_id()]})
      expect(test_client.stylists()).to(eq([test_stylist]))
    end
end

  describe('#stylists') do
    it('returns all stylists the client has') do
      test_stylist = Stylist.new({:stylist_name => 'Jon Snow'})
      test_stylist.save()
      id1 = test_stylist.stylist_id()
      test_stylist2 = Stylist.new({:stylist_name => 'Daenerys'})
      test_stylist2.save()
      id2 = test_stylist2.stylist_id()
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client.save()
      test_client.update({:stylist_ids => [id1, id2]})
      expect(test_client.stylists()).to(eq([test_stylist, test_stylist2]))
    end
  end

  describe('#delete') do
    it('deletes a client from a database') do
      test_client = Client.new({:client_name => 'Samwell Tarley'})
      test_client.save()
      id = test_client.client_id()
      test_client.delete()
      expect(Client.find(id)).to(eq(nil))
    end
  end
end
