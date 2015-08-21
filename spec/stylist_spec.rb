require('spec_helper')

describe(Stylist) do
  describe('#stylist_name') do
    it('returns the stylists name') do
      test_stylist = Stylist.new({:stylist_name => 'Daenerys'})
      expect(test_stylist.stylist_name()).to(eq('Daenerys'))
    end
  end

  describe('#==') do
    it('returns equal if two stylists have the same id') do
      test_stylist = Stylist.new({:stylist_name => 'Daenerys'})
    end
  end

  describe('.all') do
    it('will return empty at first') do
      expect(Stylist.all()).to(eq([]))
    end
  end

  describe('#save') do
    it('will save a stylist to the database') do
      test_stylist = Stylist.new({:stylist_name => 'Daenerys'})
      test_stylist.save()
      expect(Stylist.all()).to(eq([test_stylist]))
    end
  end

  describe('.find') do
    it('finds a person by their id') do
      test_stylist = Stylist.new({:stylist_name => 'Jon Snow'})
      test_stylist.save()
      expect(Stylist.find(test_stylist.stylist_id))
    end
  end

  describe('#update') do
    it('updates a stylist name that matches the id') do
      test_stylist = Stylist.new({:stylist_name => 'Jon Snow'})
      test_stylist.save()
      test_stylist.update({:stylist_name => 'jon snow'})
      expect(test_stylist.stylist_name()).to(eq('jon snow'))
    end

    it('lets you add a client to the stylist') do
      test_stylist = Stylist.new({:stylist_name => 'Jon Snow'})
      test_client = Client.new({:client_name => 'Samwell Tarly'})
      test_client2 = Client.new({:client_name => 'Gilly'})
      test_stylist.save()
      test_client.save()
      test_client2.save()
      test_stylist.update({:client_ids => [test_client.client_id()]})
      test_stylist.update({:returned_client_ids => [test_client.client_id()]})
      expect(test_client.available?()).to(eq(true))
    end
  end
end
