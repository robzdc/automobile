class CompareStatesController < ApplicationController
  before_action :set_compare_state, only: [:show, :edit, :update, :destroy]

  # GET /compare_states
  # GET /compare_states.json
  def index
    @compare_states = CompareState.all(:order => "state_id")
  end

  # GET /compare_states/1
  # GET /compare_states/1.json
  def show
  end

  # GET /compare_states/new
  def new
    @compare_state = CompareState.new

    @states = State.all
    @websites = Website.all
  end

  # GET /compare_states/1/edit
  def edit
    @states = State.all
    @websites = Website.all
  end

  # POST /compare_states
  # POST /compare_states.json
  def create
    @compare_state = CompareState.new(compare_state_params)

    respond_to do |format|
      if @compare_state.save
        format.html { redirect_to @compare_state, notice: 'Compare state was successfully created.' }
        format.json { render action: 'show', status: :created, location: @compare_state }
      else
        format.html { render action: 'new' }
        format.json { render json: @compare_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compare_states/1
  # PATCH/PUT /compare_states/1.json
  def update
    respond_to do |format|
      if @compare_state.update(compare_state_params)
        format.html { redirect_to @compare_state, notice: 'Compare state was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @compare_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_states/1
  # DELETE /compare_states/1.json
  def destroy
    @compare_state.destroy
    respond_to do |format|
      format.html { redirect_to compare_states_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compare_state
      @compare_state = CompareState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compare_state_params
      params.require(:compare_state).permit(:state_id, :website_id, :value)
    end
end
