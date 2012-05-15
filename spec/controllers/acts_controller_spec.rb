require 'spec_helper'

describe ActsController do
  
  def valid_attributes
    {name: "My Performance", description: "Sweet performance", date: Date.today}
  end

  before(:each) do
    @theater = Factory(:theater)
  end
  
  describe "GET index for a given theater" do

    it "should be successful" do
      get :index, { theater_id: @theater.id }
      response.should be_success
    end
    
    it "should assign the all acts from theater to @acts" do
      act1 = Factory(:act, theater: @theater)
      act2 = Factory(:act, name: "Another act", theater: @theater)
      get :index, { theater_id: @theater.id }
      assigns(:acts).should =~ [act1, act2]
    end

    it "should not assign acts from other theaters to @acts" do
      theater2 = Factory(:theater, name: "Theater alone" )
      act1 = Factory(:act, theater: @theater)
      act2 = Factory(:act, name: "Not belonging act", theater: theater2)
      get :index, { theater_id: @theater.id }
      assigns(:acts).should =~ [act1]
    end

  end
  
  describe "GET show" do
    it "should be successful" do
      act = Factory(:act, theater: @theater)
      get :show, {theater_id: @theater.id, id: act.id}
      response.should be_success
    end
    
    it "should assign the right act to @act" do
      act = Factory(:act, theater: @theater)
      get :show, {theater_id: @theater.id, id: act.id}
      assigns(:act).should eq(act)
    end 

    it "should not assign acts from other theaters" do
      theater2 = Factory(:theater)
      act = Factory(:act, theater: @theater)
      act2 = Factory(:act, theater: theater2)
      get :show, {theater_id: @theater.id, id: act2.id}
      assigns(:act).should_not eq(act)
    end
  end

  describe "GET new" do
    it "assings a new act to @act" do
      get :new
      assigns(:act).should be_a_new(Act)
    end
  end

  describe "GET edit" do
    it "assings the requested act as @act" do
      act = Factory(:act, theater: @theater)
      get :edit, {theater_id: @theater.id, id: act.id}
      assigns(:act).should eq(act)
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new Act" do
        expect {
          post :create, {theater_id: @theater.id, act: valid_attributes}
        }.to change(Act, :count).by(1)
      end
      
      it "redirects to created Act" do
        post :create, {theater_id: @theater.id, act: valid_attributes}
        response.should redirect_to(theater_act_path(@theater, Act.last))
      end
    end
    
    describe "with invalid params" do
      it "assings a newly created but unsaved act as @act" do
        post :create, {theater_id: @theater.id, act: {}}
        assigns(:act).should be_a_new(Act)
      end

      it "re-renders 'new' action" do
        Act.any_instance.stub(:save).and_return(false)
        post :create, {theater_id: @theater.id, act: {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "modifies the requested act" do
        act = Factory(:act, theater: @theater)
        Act.any_instance.should_receive(:update_attributes).with({"name" => "Not DT yo :("})
        put :update, {theater_id: @theater.id, id: act.id, act: {name: "Not DT yo :("}}
      end

      it "assings the requested Act as @act" do
        act = Factory(:act, theater: @theater)
        put :update, {theater_id: @theater.id, id: act.id, act: {name: "Not DT yo :("}}
        assigns(:act).should eq(act)
      end

      it "redirects to updated act" do
        act = Factory(:act, theater: @theater)
        put :update, {theater_id: @theater.id, id: act.id, act: {name: "Not DT yo :("}}
        response.should redirect_to(theater_act_path(@theater, act))
      end
    end
    
    describe "with invalid params" do
      it "re-renders 'edit' action" do
        act = Factory(:act, theater: @theater)
        Act.any_instance.stub(:save).and_return(false)
        put :update, {theater_id: @theater.id, id: act.to_param, act: {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested act" do
      act = Factory(:act, theater: @theater)
      expect {
        delete :destroy, {theater_id: @theater.id, id: act.to_param}
      }.to change(Act, :count).by(-1)
    end

    it "redirects to the act list" do
      act = Factory(:act, theater: @theater)
      delete :destroy, {theater_id: @theater.id, id: act.to_param}
      response.should redirect_to(theater_acts_path(@theater))
    end
  end

end