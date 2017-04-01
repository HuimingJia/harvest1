class MarketsController < ApplicationController
  include ApplicationHelper
  before_action :set_market, only: [:show, :edit, :update, :destroy]

  # GET /markets
  # GET /markets.json
  def index
    @markets = Market.all
  end

  # GET /markets/1
  # GET /markets/1.json
  def show
    @market = Market.find(params[:id])
    @stores = @market.stores
    # @stores.each do |s|
    #   puts s.description
    # end
    # puts "***********************"
    # puts @params;
    # puts "***********************"
    # @market = Market.find(@params[:id])
    # puts @market
    # @stores = @market.stores
  end

  # GET /markets/new
  def new
    @market = Market.new
  end

  # GET /markets/1/edit
  def edit
  end

  # POST /markets
  # POST /markets.json
  def create
    @market = Market.new(name: params['market']['name'],
    city: params['market']['city'],
    state: params['market']['state'],
    zipcode: params['market']['zipcode'],
    rating: 0,
    description: params['market']['description'],
    open_time: timestampe_helper(params['open_day'], params['market']['open_time']),
    close_time: timestampe_helper(params['open_day'], params['market']['close_time']))
    respond_to do |format|
      if @market.save
        format.html { redirect_to @market, notice: 'Market was successfully created.' }
        format.json { render :show, status: :created, location: @market }
      else
        format.html { render :new }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /markets/1
  # PATCH/PUT /markets/1.json
  def update
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to @market, notice: 'Market was successfully updated.' }
        format.json { render :show, status: :ok, location: @market }
      else
        format.html { render :edit }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.json
  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to markets_url, notice: 'Market was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market
      @market = Market.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_params
      params.require(:market).permit(:city, :state, :zipcode, :rating, :description, :open_time, :close_time)
    end
end
