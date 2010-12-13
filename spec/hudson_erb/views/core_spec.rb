require File.expand_path('../../../spec_helper', __FILE__)

describe "Hudson::View::Core" do
  subject { Hudson::ERB.new }

  context "rendering a forEach loop" do
    it 'uses descriptor as object to look for the collection variable by default' do
      for_each = subject.for_each :items
      for_each.should include('items="${descriptor.items}"')
    end

    it 'uses `it` as default name for the variable to iterate with' do
      for_each = subject.for_each :items
      for_each.should include('var="it"')
    end

    it "uses the complete parameter as items collections when it's surrounded by ${}" do
      for_each = subject.for_each '${instance.installations}'
      for_each.should include('items="${instance.installations}"')
    end

    it "adds other attributes included into the options parameter" do
      for_each = subject.for_each :items, {:step => 2}
      for_each.should include('step="2"')
    end

    it "overrides the varible with the option `:var`" do
      for_each = subject.for_each :items, :var => 'var'
      for_each.should include('var="var"')
    end

    it "executes a block when it's given" do
      out = ''
      subject.for_each :items do
        out = 'out'
      end
      out.should == 'out'
    end

    it "passes the variable to iterate with into the block" do
      out = ''
      subject.for_each :items do |var|
        out = var
      end
      out.should == 'it'
    end
  end
end
