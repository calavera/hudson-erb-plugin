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
end
