require "spec_helper"

module Rushiro
  describe "Allow all deny some Access Control" do
    let(:access_control) { DenyBasedControl.new(acl)}
    describe "with no set permissions" do
      let(:acl) { Hash.new }
      it "should deny all" do
        access_control.permitted?("page|view|posts").should be_true
        access_control.serialize.should == {}
        access_control.changed.should be_false
      end
    end

    describe "when adding a denies permission" do
      let(:acl) { Hash.new }
      before do
        access_control.add_permission("denies|individual|company|edit|acme-123")
      end
      it "should add the permission" do
        access_control.changed.should be_true
        access_control.serialize.should_not == {}
        access_control.permitted?("company|view|acme-125").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
        access_control.permitted?("page|view|posts").should be_true
      end
    end

    describe "when removing a denies permission" do
      let(:acl) { Hash.new }
      before do
        access_control.add_permission("denies|individual|company|edit|acme-123")
        access_control.add_permission("denies|organization|page|edit")
      end
      it "should remove the permission" do
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
        access_control.changed.should be_false
      end
    end

    describe "when adding an allows permission" do
      let(:acl) { Hash.new }
      before do
        access_control.add_permission("allows|individual|page")
      end
      it "should add the permission" do
        access_control.permitted?("page|view|posts").should be_true
        access_control.permitted?("company|edit|acme-123").should be_false
      end
    end
  end

  describe "Exception Handling" do
    let(:access_control) { AllowBasedControl.new(Hash.new)}
    it "should raise errors" do
      expect {access_control.add_permission("grant|individual|page")}.to raise_error(ArgumentError)
      expect {access_control.add_permission("allows|individula|page")}.to raise_error(ArgumentError)
      expect {access_control.add_permission("allows|system")}.to raise_error(ArgumentError)
    end
  end

  describe "Permissions with more elements" do
    let(:access_control) { AllowBasedControl.new(Hash.new)}
    before do
      access_control.add_permission("allow|individual|company|acme-123|page|view,edit|admin|settings")
    end
    it "should still control access" do
      access_control.permitted?("company|acme-123|page|edit|admin|settings").should be_true
      access_control.permitted?("company|acme-123|page|edit|admin|tasks").should be_false
    end
  end

  describe "Using Allow based chain with subordinate having set permissions" do
    let(:access_control) { AllowBasedControl.new(acl)}
    let(:sub_control) { AllowBasedControl.new(sub_acl)}    
    let(:acl) { Hash.new }
    let(:sub_acl) { Hash[:name, 'Sub4test'] }
    before do
      sub_control.add_permission("allows|individual|page")
      access_control.add_subordinate(sub_control)
    end
    it "should allow some" do
      access_control.permitted?("page|view|posts").should be_true
      access_control.serialize.should == {}
      access_control.changed.should be_false
    end
  end

  describe "Using Deny based chain with subordinate having set permissions" do
    let(:access_control) { DenyBasedControl.new(acl)}
    let(:sub_control) { DenyBasedControl.new(sub_acl)}
    let(:acl) { Hash.new }
    let(:sub_acl) { Hash[:name, 'Sub4test'] }
    before do
      sub_control.add_permission("denies|system|admin")
      access_control.add_subordinate(sub_control)
    end
    it "should deny some" do
      access_control.permitted?("admin|view|users").should be_false
      access_control.permitted?("page|view|posts").should be_true
      access_control.serialize.should == {}
      access_control.changed.should be_false
    end
  end
end
