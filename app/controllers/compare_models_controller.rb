class CompareModelsController < ApplicationController
  # GET /compare_models
  # GET /compare_models.json
  def index
    #@compare_models = CompareModel.all(:order => "model_id,website_id")
    @compare_models = Model.select("compare_models.id,compare_models.model_id,models.name,compare_models.value,compare_models.website_id").joins(:compare_models).order(:model_id,:website_id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compare_models }
    end
  end

  # GET /compare_models/1
  # GET /compare_models/1.json
  def show
    @compare_model = CompareModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compare_model }
    end
  end

  # GET /compare_models/new
  # GET /compare_models/new.json
  def new
    @compare_model = CompareModel.new
    
    @models = Model.where(:make_id => 4).order(:name)
    #@models = Model.all(:order => "make_id")
    @websites = Website.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compare_model }
    end
  end

  # GET /compare_models/1/edit
  def edit
    @compare_model = CompareModel.find(params[:id])
    @models = Model.all
    @websites = Website.all
  end

  # POST /compare_models
  # POST /compare_models.json
  def create
    @compare_model = CompareModel.new(params[:compare_model])

    respond_to do |format|
      if @compare_model.save
        format.html { redirect_to @compare_model, notice: 'Compare model was successfully created.' }
        format.json { render json: @compare_model, status: :created, location: @compare_model }
      else
        format.html { render action: "new" }
        format.json { render json: @compare_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compare_models/1
  # PUT /compare_models/1.json
  def update
    @compare_model = CompareModel.find(params[:id])

    respond_to do |format|
      if @compare_model.update_attributes(params[:compare_model])
        format.html { redirect_to @compare_model, notice: 'Compare model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compare_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_models/1
  # DELETE /compare_models/1.json
  def destroy
    @compare_model = CompareModel.find(params[:id])
    @compare_model.destroy

    respond_to do |format|
      format.html { redirect_to compare_models_url }
      format.json { head :no_content }
    end
  end
end
