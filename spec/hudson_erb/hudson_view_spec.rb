require File.expand_path('../../spec_helper', __FILE__)

describe "Hudson::View" do
  subject { Hudson::ERB.new }

  it "creates jelly views blocks with the default namespaces" do
    expected = %q{<j:jelly xmlns:j="jelly:core" xmlns:st="jelly:stapler" xmlns:d="jelly:define" xmlns:l="/lib/layout"
         xmlns:t="/lib/hudson" xmlns:f="/lib/form" ></j:jelly>}

    subject.view.should == expected
  end

  it "adds other namespaces and attributes to the initial tag" do
    view = subject.view({
      'xmlns:foo' => 'lib/foo',
      'name' => 'jelly_view'
    })

    view.should include('xmlns:foo="lib/foo"')
    view.should include('name="jelly_view"')
  end

  it "can invoke a block if it's given" do
    output = ''
    subject.view { output << '<input/>' }

    output.should == '<input/>'
  end
end
