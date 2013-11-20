class CompareModelsController < ApplicationController
  before_action :set_compare_model, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /compare_models
  # GET /compare_models.json
  def index
    @compare_models = Model.select("compare_models.id,compare_models.model_id,models.name,compare_models.value,compare_models.website_id").joins(:compare_models).order("models.id, compare_models.website_id")
  end

  # GET /compare_models/1
  # GET /compare_models/1.json
  def show
  end

  # GET /compare_models/new
  def new
    @compare_model = CompareModel.new
    @models = Model.where(:make_id => 4).order(:name)
    @websites = Website.all
  end

  # GET /compare_models/1/edit
  def edit
    @models = Model.all
    @websites = Website.all
  end

  # POST /compare_models
  # POST /compare_models.json
  def create
    @compare_model = CompareModel.new(compare_model_params)

    respond_to do |format|
      if @compare_model.save
        format.html { redirect_to @compare_model, notice: 'Compare model was successfully created.' }
        format.json { render action: 'show', status: :created, location: @compare_model }
      else
        format.html { render action: 'new' }
        format.json { render json: @compare_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compare_models/1
  # PATCH/PUT /compare_models/1.json
  def update
    respond_to do |format|
      if @compare_model.update(compare_model_params)
        format.html { redirect_to @compare_model, notice: 'Compare model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @compare_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_models/1
  # DELETE /compare_models/1.json
  def destroy
    @compare_model.destroy
    respond_to do |format|
      format.html { redirect_to compare_models_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compare_model
      @compare_model = CompareModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compare_model_params
      params.require(:compare_model).permit(:model_id, :website_id, :value)
    end
end
