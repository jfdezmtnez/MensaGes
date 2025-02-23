class TariffsController < ApplicationController
  before_action :set_tariff, only: %i[ show edit update destroy ]

  # GET /tariffs or /tariffs.json
  def index
    @tariffs = Tariff.all
  end

  # GET /tariffs/1 or /tariffs/1.json
  def show
  end

  # GET /tariffs/new
  def new
    @tariff = Tariff.new
  end

  # GET /tariffs/1/edit
  def edit
  end

  # POST /tariffs or /tariffs.json
  def create
    @tariff = Tariff.new(tariff_params)

    respond_to do |format|
      if @tariff.save
        format.html { redirect_to @tariff, notice: "Tariff was successfully created." }
        format.json { render :show, status: :created, location: @tariff }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tariffs/1 or /tariffs/1.json
  def update
    respond_to do |format|
      if @tariff.update(tariff_params)
        format.html { redirect_to @tariff, notice: "Tariff was successfully updated." }
        format.json { render :show, status: :ok, location: @tariff }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tariffs/1 or /tariffs/1.json
  def destroy
    @tariff.destroy!

    respond_to do |format|
      format.html { redirect_to tariffs_path, status: :see_other, notice: "Tariff was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tariff
      @tariff = Tariff.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tariff_params
      params.expect(tariff: [ :description, :weight, :distance, :duration, :price ])
    end
end
