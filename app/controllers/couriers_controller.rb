class CouriersController < ApplicationController
  before_action :set_courier, only: %i[ show edit update destroy ]

  # GET /couriers or /couriers.json
  def index
    @couriers = Courier.all
  end

  # GET /couriers/1 or /couriers/1.json
  def show
  end

  # GET /couriers/new
  def new
    @courier = Courier.new
  end

  # GET /couriers/1/edit
  def edit
  end

  # POST /couriers or /couriers.json
  def create
    @courier = Courier.new(courier_params)

    respond_to do |format|
      if @courier.save
        format.html { redirect_to @courier, notice: "Courier was successfully created." }
        format.json { render :show, status: :created, location: @courier }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @courier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couriers/1 or /couriers/1.json
  def update
    respond_to do |format|
      if @courier.update(courier_params)
        format.html { redirect_to @courier, notice: "Courier was successfully updated." }
        format.json { render :show, status: :ok, location: @courier }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @courier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couriers/1 or /couriers/1.json
  def destroy
    @courier.destroy!

    respond_to do |format|
      format.html { redirect_to couriers_path, status: :see_other, notice: "Courier was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_courier
      @courier = Courier.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def courier_params
      params.expect(courier: [ :person_id, :settings ])
    end
end
