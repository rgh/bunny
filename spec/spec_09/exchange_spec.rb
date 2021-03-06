# exchange_spec.rb

# Assumes that target message broker/server has a user called 'guest' with a password 'guest'
# and that it is running on 'localhost'.

# If this is not the case, please change the 'Bunny.new' call below to include
# the relevant arguments e.g. @b = Bunny.new(:user => 'john', :pass => 'doe', :host => 'foobar')

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. lib bunny]))

describe Bunny do
	
	before(:each) do
    @b = Bunny.new(:spec => '09')
		@b.start
	end
		
	it "should raise an error if instantiated as non-existent type" do
		lambda { @b.exchange('bogus_ex', :type => :bogus) }.should raise_error(Bunny::ProtocolError)
	end
	
	it "should allow a default direct exchange to be instantiated by specifying :type" do
		exch = @b.exchange('amq.direct', :type => :direct)
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.direct'
		exch.type.should == :direct
		@b.exchanges.has_key?('amq.direct').should be true
	end
	
	it "should allow a default direct exchange to be instantiated without specifying :type" do
		exch = @b.exchange('amq.direct')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.direct'
		exch.type.should == :direct
		@b.exchanges.has_key?('amq.direct').should be true
	end
	
	it "should allow a default fanout exchange to be instantiated without specifying :type" do
		exch = @b.exchange('amq.fanout')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.fanout'
		exch.type.should == :fanout
		@b.exchanges.has_key?('amq.fanout').should be true
	end
	
	it "should allow a default topic exchange to be instantiated without specifying :type" do
		exch = @b.exchange('amq.topic')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.topic'
		exch.type.should == :topic
		@b.exchanges.has_key?('amq.topic').should be true
	end

	it "should allow a default headers (amq.match) exchange to be instantiated without specifying :type" do
		exch = @b.exchange('amq.match')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.match'
		exch.type.should == :headers
		@b.exchanges.has_key?('amq.match').should be true
	end
	
	it "should allow a default headers (amq.headers) exchange to be instantiated without specifying :type" do
		exch = @b.exchange('amq.headers')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'amq.headers'
		exch.type.should == :headers
		@b.exchanges.has_key?('amq.headers').should be true
	end
	
	it "should create an exchange as direct by default" do
		exch = @b.exchange('direct_defaultex')
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'direct_defaultex'
		exch.type.should == :direct
		@b.exchanges.has_key?('direct_defaultex').should be true
	end
	
	it "should be able to be instantiated as a direct exchange" do
		exch = @b.exchange('direct_exchange', :type => :direct)
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'direct_exchange'
		exch.type.should == :direct
		@b.exchanges.has_key?('direct_exchange').should be true
	end
	
	it "should be able to be instantiated as a topic exchange" do
		exch = @b.exchange('topic_exchange', :type => :topic)
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'topic_exchange'
		exch.type.should == :topic
		@b.exchanges.has_key?('topic_exchange').should be true
	end
	
	it "should be able to be instantiated as a fanout exchange" do
		exch = @b.exchange('fanout_exchange', :type => :fanout)
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'fanout_exchange'
		exch.type.should == :fanout
		@b.exchanges.has_key?('fanout_exchange').should be true
	end

	it "should be able to be instantiated as a headers exchange" do
		exch = @b.exchange('headers_exchange', :type => :headers)
		exch.should be_an_instance_of Bunny::Exchange09
		exch.name.should == 'headers_exchange'
		exch.type.should == :headers
		@b.exchanges.has_key?('headers_exchange').should be true
	end
		
	it "should ignore the :nowait option when instantiated" do
		exch = @b.exchange('direct2_exchange', :nowait => true)
	end
	
	it "should be able to publish a message" do
		exch = @b.exchange('direct_exchange')
		exch.publish('This is a published message')
	end
	
	it "should be able to be deleted" do
		exch = @b.exchange('direct_exchange')
		res = exch.delete
		res.should == :delete_ok
		@b.exchanges.has_key?('direct_exchange').should be false
	end
	
	it "should ignore the :nowait option when deleted" do
		exch = @b.exchange('direct2_exchange')
		exch.delete(:nowait => true)
	end
	
end