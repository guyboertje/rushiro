require "spec_helper"

module Rushiro
  describe "Allow all deny some Access Control" do
    let(:access_control) { DenyBasedControl.new(acl)}
    describe "with no set permissions" do
      let(:acl) { Hash.new }
      it "should deny all" do
        access_control.permitted?("page|view|posts").should be_true
        access_control.serialize.should == {}
        access_control.dirty.should be_false
      end
    end

    describe "when adding a denies permission" do
      let(:acl) { Hash.new }
      it "should add the permission" do
        access_control.add_permission("denies|individual|company|edit|acme-123")
        access_control.dirty.should be_true
        access_control.serialize.should_not == {}
        access_control.permitted?("page|view|posts").should be_true
        access_control.permitted?("company|view|acme-125").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
      end
    end

    describe "when removing a denies permission" do
      let(:acl) { Hash.new }
      it "should remove the permission" do
        access_control.add_permission("denies|individual|company|edit|acme-123")
        access_control.add_permission("denies|organization|page|edit")
        access_control.permitted?("page|view|settings").should be_true
        access_control.permitted?("page|edit|settings").should be_false
        access_control.permitted?("company|edit|acme-123").should be_false
        access_control.remove_permission("denies|organization|page|edit")
        access_control.permitted?("page|view|settings").should be_true
        access_control.permitted?("page|edit|settings").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
      end
    end
  end

  describe "Deny all allow some Access Control" do
    let(:access_control) { AllowBasedControl.new(acl)}
    describe "with no set permissions" do
      let(:acl) { Hash.new }
      it "should deny all" do
        access_control.permitted?("page|view|posts").should be_false
        access_control.serialize.should == {}
        access_control.dirty.should be_false
      end
    end

    describe "when adding an allows permission" do
      let(:acl) { Hash.new }
      it "should add the permission" do
        access_control.add_permission("allows|individual|page")
        access_control.permitted?("page|view|posts").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
      end
    end
  end
end
