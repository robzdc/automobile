class CompareMakesController < ApplicationController
  # GET /compare_makes
  # GET /compare_makes.json
  def index
    @compare_makes = CompareMake.all(:order => "make_id")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compare_makes }
    end
  end

  # GET /compare_makes/1
  # GET /compare_makes/1.json
  def show
    @compare_make = CompareMake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compare_make }
    end
  end

  # GET /compare_makes/new
  # GET /compare_makes/new.json
  def new
    @compare_make = CompareMake.new
    
    @marcas = Make.all
    @websites = Website.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compare_make }
    end
  end

  # GET /compare_makes/1/edit
  def edit
    @compare_make = CompareMake.find(params[:id])
    @marcas = Make.all
    @websites = Website.all
  end

  # POST /compare_makes
  # POST /compare_makes.json
  def create
    @compare_make = CompareMake.new(params[:compare_make])

    respond_to do |format|
      if @compare_make.save
        format.html { redirect_to @compare_make, notice: 'Compare make was successfully created.' }
        format.json { render json: @compare_make, status: :created, location: @compare_make }
      else
        format.html { render action: "new" }
        format.json { render json: @compare_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compare_makes/1
  # PUT /compare_makes/1.json
  def update
    @compare_make = CompareMake.find(params[:id])

    respond_to do |format|
      if @compare_make.update_attributes(params[:compare_make])
        format.html { redirect_to @compare_make, notice: 'Compare make was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compare_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compare_makes/1
  # DELETE /compare_makes/1.json
  def destroy
    @compare_make = CompareMake.find(params[:id])
    @compare_make.destroy

    respond_to do |format|
      format.html { redirect_to compare_makes_url }
      format.json { head :no_content }
    end
  end
end
