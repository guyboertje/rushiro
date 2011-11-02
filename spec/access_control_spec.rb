require "spec_helper"

module Rushiro
  describe "Allow all deny some Access Control" do
    let(:access_control) { DenyBasedControl.new(acl)}
    describe "with no set permissions" do
      let(:acl) { Hash.new }
      it "should allow all" do
        access_control.permitted?("page|view|posts").should be_true
        access_control.serialize.should == {}
        access_control.dirty.should be_false
      end
    end
    describe "when adding a denies permission" do
      let(:acl) { Hash.new }
      it "should add the permission" do
        access_control.add_permission("denies|system|company|edit|acme-123")
        access_control.dirty.should be_true
        access_control.serialize.should_not == {}
        apr access_control.serialize, 'added to control'
        access_control.permitted?("page|view|posts").should be_true
        access_control.permitted?("company|view|acme-125").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
      end
    end
    describe "when removing a denies permission" do
      let(:acl) { Hash.new }
      it "should remove the permission" do
        access_control.add_permission("denies|individual|company|edit|acme-123")
        access_control.add_permission("denies|individual|page|edit")
        apr access_control.serialize, 'added to control'
        access_control.permitted?("page|view|posts").should be_true
        access_control.permitted?("page|edit|settings").should be_false
        access_control.permitted?("company|edit|acme-123").should be_false
        access_control.remove_permission("denies|individual|page|edit")
        access_control.permitted?("page|edit|settings").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
        apr access_control.serialize, 'added to control'
      end
    end
  end
end
