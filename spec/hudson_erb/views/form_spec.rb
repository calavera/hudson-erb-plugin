require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../field', __FILE__)

describe "Hudson::View::Form" do
  subject { Hudson::ERB.new }

  it "creates entry blocks for formularies" do
    expected = '<f:entry name="foo"></f:entry>'

    subject.entry('foo').should == expected
  end

  it "can add custom attributes to the entry initial tag" do
    entry = subject.entry('foo', :description => 'this is an entry')

    entry.should include('name="foo"')
    entry.should include('description="this is an entry"')
  end

  it "can run a block if it's given" do
    output = ''
    subject.entry('foo') { output << '<input/>' }

    output.should == '<input/>'
  end

  context "rendering textboxes" do
    before(:each) do
      @method = 'textbox'
      @value_attr = 'value'
    end

    it_should_behave_like "all form fields"
  end

  context "rendering expandable textboxes" do
    before(:each) do
      @method = 'expandable_textbox'
      @value_attr = 'value'
    end

    it_should_behave_like "all form fields"
  end

  context "rendering textareas" do
    before(:each) do
      @method = 'textarea'
      @value_attr = 'value'
    end

    it_should_behave_like "all form fields"
  end

  context "rendering checkboxes" do
    before(:each) do
      @method = 'checkbox'
      @value_attr = 'checked'
    end
    it_should_behave_like "all form fields"
  end

  context "rendering a list of options for a select box" do
    it "uses `option` as default variable name for the loop" do
      options = subject.options_for 'installations', 'installation'
      options.should include('var="option"')
    end

    it "uses descriptor.`first_parameter` as items list by default" do
      options = subject.options_for 'installations', 'installation'
      options.should include('items="${descriptor.installations}"')
    end

    it "uses instance.`second_parameter` as name of the selected item by default" do
      options = subject.options_for 'installations', 'installation'
      options.should include('selected="${option.name == instance.installation}"')
    end

    it "can override the variable name for the loop with the option :var" do
      options = subject.options_for 'installations', 'installation', {:var => 'foo'}
      options.should include('var="foo"')
      options.should include('${foo.name}</f:option>')
    end

    it "can override the items name with the option :items" do
      options = subject.options_for 'installations', 'installation', :items => '${instance.foo}'
      options.should include('items="${instance.foo}"')
    end

    it "can override the selected item with the option :selected" do
      options = subject.options_for 'installations', 'installation', :selected => "instance.foo"
      options.should include('selected="${option.name == instance.foo}"')
    end

    it "can override the value to show and compare in the list with the option :value" do
      options = subject.options_for 'installations', 'installation', :value => 'value'
      options.should include('selected="${option.value == instance.installation}"')
      options.should include('${option.value}</f:option>')
    end
  end
end
