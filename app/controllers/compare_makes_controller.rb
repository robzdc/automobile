class CompareMakesController < ApplicationController
  before_action :set_compare_make, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /compare_makes
  # GET /compare_makes.json
  def index
    @compare_makes = CompareMake.order("make_id")
  end

  # GET /compare_makes/1
  # GET /compare_makes/1.json
  def show
  end

  # GET /compare_makes/new
  def new
    @compare_make = CompareMake.new
  end

  # GET /compare_makes/1/edit
  def edit
  end

  # POST /compare_makes
  # POST /compare_makes.json
  def create
    @compare_make = CompareMake.new(compare_make_params)

    respond_to do |format|
      if @compare_make.save
        format.html { redirect_to @compare_make, notice: 'Compare make was successfully created.' }
        format.json { render action: 'show', status: :created, location: @compare_make }
      else
        format.html { render action: 'new' }
        format.json { render json: @compare_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compare_makes/1
  # PATCH/PUT /compare_makes/1.json
  def update
    respond_to do |format|
      if @compare_make.update(compare_make_params)
        format.html { redirect_to @compare_make, notice: 'Compare make was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @compare_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_makes/1
  # DELETE /compare_makes/1.json
  def destroy
    @compare_make.destroy
    respond_to do |format|
      format.html { redirect_to compare_makes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compare_make
      @compare_make = CompareMake.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compare_make_params
      params.require(:compare_make).permit(:make_id, :website_id, :value)
    end
end
