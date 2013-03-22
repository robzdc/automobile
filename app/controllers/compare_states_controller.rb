class CompareStatesController < ApplicationController
  # GET /compare_states
  # GET /compare_states.json
  def index
    @compare_states = CompareState.all(:order => "state_id")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compare_states }
    end
  end

  # GET /compare_states/1
  # GET /compare_states/1.json
  def show
    @compare_state = CompareState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compare_state }
    end
  end

  # GET /compare_states/new
  # GET /compare_states/new.json
  def new
    @compare_state = CompareState.new
    
    @states = State.all
    @websites = Website.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compare_state }
    end
  end

  # GET /compare_states/1/edit
  def edit
    @compare_state = CompareState.find(params[:id])
    @states = State.all
    @websites = Website.all
  end

  # POST /compare_states
  # POST /compare_states.json
  def create
    @compare_state = CompareState.new(params[:compare_state])

    respond_to do |format|
      if @compare_state.save
        format.html { redirect_to @compare_state, notice: 'Compare state was successfully created.' }
        format.json { render json: @compare_state, status: :created, location: @compare_state }
      else
        format.html { render action: "new" }
        format.json { render json: @compare_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compare_states/1
  # PUT /compare_states/1.json
  def update
    @compare_state = CompareState.find(params[:id])

    respond_to do |format|
      if @compare_state.update_attributes(params[:compare_state])
        format.html { redirect_to @compare_state, notice: 'Compare state was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compare_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_states/1
  # DELETE /compare_states/1.json
  def destroy
    @compare_state = CompareState.find(params[:id])
    @compare_state.destroy

    respond_to do |format|
      format.html { redirect_to compare_states_url }
      format.json { head :no_content }
    end
  end
end
