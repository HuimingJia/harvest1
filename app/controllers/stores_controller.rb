class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :create, :edit, :update]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = Store.find(params[:id])
    if !params[:group] or params[:group] == "All"
      @products = @store.products.all.paginate(page:1,per_page:6)
      @group = "All"
    else
      @products = @store.products.where(:group => params[:group]).paginate(page:1,per_page:6)
      @group = params[:group]
    end
    @reviews = @store.store_reviews.all.order("created_at DESC").paginate(page:1,per_page:5)
    @current_page = 1
    @review = StoreReview.new(store_id: params[:id])
  end

  def ajax_reviews
    @store = Store.find(params[:id])
    @reviews = @store.store_reviews.all.order("created_at DESC").paginate(page:params['current_review_page'].to_i + 1,per_page:5)
    if @reviews.length > 0
      render  partial: "shared/reviews", locals: { reviews: @reviews }
    else
      render :html => "", :status => :ok
    end
  end

  def ajax_products
    @store = Store.find(params[:id])
    if !params[:group] or params[:group] == "All"
      @products = @store.products.all.paginate(page:params['current_product_page'].to_i + 1,per_page:6)
    else
      @products = @store.products.where(:group => params[:group]).paginate(page:params['current_product_page'].to_i + 1,per_page:6)
    end

    if @products.length > 0
      render partial: "shared/products_sm", locals: { products: @products}
    else
      render :html => "", :status => :ok
    end
  end

  # GET /stores/new
  def new
    #need to be change
    @store = Store.new()
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    # puts current_user
    # puts current_user.name
    if !@vendor = Vendor.create!(user_id: current_user.id)
      render json: {error: @vendor.errors.full_messages.join(',')}, status: :unprocessable_entity
    end

    market_ids = params['market_ids'].split(',')
    market_ids = market_ids.uniq
    @store = Store.new(store_params)
    @store.vendor_id = @vendor.id

    if @store.save
      market_ids.each do |market_id|
        Request.create(
        market_id: market_id,
        store_id: @store.id,
        status: 0
        )
      end
      render json: {statue: 'Create successfully.'}
    else
      render json: {error: @store.errors.full_messages.join(',')}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def ajax_search_markets
    # search function implementation
    q = params[:query]
    @markets = Market.ransack(name_or_description_cont: q).result

    respond_to do |format|
      # format.html { render  partial: "shared/stores", locals: { stores: @stores }}
      format.json { render json: {markets: @markets}}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:store).permit(:description, :name)
  end
end
