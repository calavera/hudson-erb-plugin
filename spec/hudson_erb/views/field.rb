shared_examples_for "all form fields" do
  it "uses a given name and ${instance.given_name} as default value" do
    text = subject.send(@method, 'foo')

    text.should include('name="foo"')
    text.should include(%Q{#{@attr_value}="${instance.foo}"})
  end

  it "uses the name of the method in camelcase as field attribute name" do
    text = subject.send(@method, 'foo')

    field_name = @method.gsub(/(?:_)(.)/) { $1.upcase }
    text.should include("f:#{field_name}")
  end

  it "can use custom attributes" do
    text = subject.send(@method, 'foo', :class => 'class_style')
    text.should include('class="class_style"')
  end

  it "can use a prefix for the field name separated with a dot" do
    text = subject.send(@method, 'foo.bar')

    text.should include('name="foo.bar"')
    text.should include(%Q{#{@attr_value}="${instance.bar}"})
  end

  it "can override the default value" do
    text = subject.send(@method, 'foo', @value_attr => '${other_instance.foo}')
    text.should include(%Q{#{@attr_value}="${other_instance.foo}"})
  end

  it "can use symbols as field names" do
    text = subject.send(@method, :foo)
    text.should include('name="foo"')
  end
end
