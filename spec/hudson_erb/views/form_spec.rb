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

    it "can override the variable name for the loop" do
      options = subject.options_for 'installations', 'installation', 'foo'
      options.should include('var="foo"')
      options.should include('${foo.name}</f:option>')
    end

    it "can override the items name" do
      options = subject.options_for '${instance.foo}', 'installation'
      options.should include('items="${instance.foo}"')
    end

    it "removes brackets from the instance variable name if it includes them" do
      options = subject.options_for 'installations', '${instance.foo}'
      options.should include('selected="${option.name == instance.foo}"')
    end

    it "can override the value to show and compare in the list" do
      options = subject.options_for 'installations', 'installation', 'option', 'value'
      options.should include('selected="${option.value == instance.installation}"')
      options.should include('${option.value}</f:option>')
    end
  end

  context "rendering a validation button" do
    it "needs title as mandatory arguments" do
      button = subject.validate_button 'Validate', 'accessKey'
      button.should include('title="Validate"')
    end

    it "needs form fields to send to the server" do
      button = subject.validate_button 'Validate', 'secretKey,accessKey'
      button.should include('with="secretKey,accessKey"')
    end

    it "uses `validate` as default name for the server method that checks the fields" do
      button = subject.validate_button 'Validate', 'accessKey'
      button.should include('method="validate"')
    end

    it "can use an alternative method name" do
      button = subject.validate_button 'Validate', 'secretKey', 'testConnection'
      button.should include('method="testConnection"')
    end


    it "can use a sentence to show while the method is in progress" do
      button = subject.validate_button 'Validate', 'secretKey,accessKey', 'testConnection', 'checking connection'
      button.should include('progress="checking connection"')
    end
  end

  context "rendering an advanced block" do
    it "shows the advanced element tags and executes the block passed as a paramter" do
      out = ''

      advanced = subject.advanced { out = 'block' }
      out.should == 'block'
      advanced.should == '<f:advanced></f:advanced>'
    end
  end

  context "rendering a section" do
    it "shows the section with a title and executes the block passed as a paramter" do
      out = ''

      section = subject.section('Options') { out = 'block' }
      out.should == 'block'
      section.should == '<f:section title="Options"></f:section>'
    end
  end

  context "rendering an optional block" do
    it "shows the name and the title parameters given and it's not checked by default" do
      block = subject.optional_block :dynamic, 'Use dynamic'

      block.should include('name="dynamic"')
      block.should include('title="Use dynamic"')
      block.should include('checked="false"')
    end

    it "can render the checkbox checked" do
      block = subject.optional_block :dynamic, 'Use dynamic', true
      block.should include('checked="true"')
    end

    it "executes the given block" do
      out = ''
      block = subject.optional_block :dynamic, 'Use dynamic' do
        out = 'block'
      end

      out.should == 'block'
      block.should == '<f:optionalBlock name="dynamic" title="Use dynamic" checked="false"></f:optionalBlock>'
    end
  end

  context "rendering a block" do
    it "shows the block element tags and executes the block passed as a paramter" do
      out = ''

      advanced = subject.block { out = 'block' }
      out.should == 'block'
      advanced.should == '<f:block></f:block>'
    end
  end

  context "rendering a boolean radio" do
    it "uses booleanRadio as the name of the element" do
      radio = subject.boolean_radio 'option'
      radio.should include('<f:booleanRadio')
    end

    it "uses the first parameter as a field to bind" do
      radio = subject.boolean_radio 'option'
      radio.should include('field="option"')
    end

    it "uses `No` and `Yes` as default values for the false and true fields" do
      radio = subject.boolean_radio 'option'
      radio.should include('false="No"')
      radio.should include('true="Yes"')
    end

    it "can use any other values for the true and false fields" do
      radio = subject.boolean_radio 'option', 'Cancel', 'Accept'
      radio.should include('false="Cancel"')
      radio.should include('true="Accept"')
    end
  end

  context "rendering a combobox" do
    it "takes the field name as value for the field element" do
      combo = subject.combobox :countries
      combo.should == '<f:combobox field="countries"/>'
    end

    it "can add addition css classes" do
      combo = subject.combobox :countries, :list
      combo.should == '<f:combobox field="countries" clazz="list"/>'
    end
  end

  context "rendering a form" do
    it "uses name, action and method as required arguments" do
      form = subject.form :form, '/submit'
      form.should == '<f:form name="form" action="/submit" method="post" ></f:form>'
    end

    it "uses the option :method to override the form method" do
      form = subject.form :form, '/submit', :method => :get
      form.should == '<f:form name="form" action="/submit" method="get" ></f:form>'
    end

    it "can execute a block when it's given" do
      out = ''
      subject.form :form, '/submit' do
        out = 'submit'
      end

      out.should == 'submit'
    end
  end

  context "rendering a submit button" do
    it "takes the mandatory parameter as the element value" do
      submit = subject.submit :OK
      submit.should == '<f:submit value="OK"/>'
    end

    it "can takes a name to determinate which button is pressed" do
      submit = subject.submit :OK, :submit_1
      submit.should == '<f:submit value="OK" name="submit_1"/>'
    end
  end
end
