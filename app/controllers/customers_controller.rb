class CustomersController < ApplicationController

  include TemporaryUploadSupport

  before_filter :authenticate_user!

  before_filter :remember_avatar, :only => [:create, :update]
  after_filter :consume_avatar, :only => [:create]


  # GET /customers
  # GET /customers.json
  def index
    if !params[:keyword].nil?
      @customers = Customer.find_by_keyword(params[:keyword])
    elsif !params[:geom].nil?
      @customers = Customer.find_by_geom(params[:geom])
    else
      @customers = Customer.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @customers }
      format.geojson { }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])
    @customer.company_avatar = @company_avatar

    respond_to do |format|
      if @customer.save

        format.html { redirect_to @customer, notice: I18n.t('views.company.flash_messages.created_successfully') }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    customer_params = params[:customer]
    @customer = Customer.find(params[:id])
    @customer.company_avatar = @company_avatar

    respond_to do |format|
      if @customer.update_attributes(customer_params)
        format.html { redirect_to @customer, notice: I18n.t('views.company.flash_messages.updated_successfully')  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  # todo: this method looks like index. refactor it!
  def map
    keyword = params[:keyword]
    if keyword.nil?
      @customers = Customer.all
    else
      @customers = Customer.where("name LIKE '%#{keyword}%'")
    end

    respond_to do |format|
      format.html # map.html.erb
      format.json { render json: @customers }
    end
  end

  private
  def remember_avatar
    company_avatar_id = params[:customer][:company_avatar]

    @company_avatar = CompanyAvatar.find_by_id( company_avatar_id.to_i )
    if not @company_avatar.nil?
      params[:customer][:company_avatar] = @company_avatar
      remember_temp_upload company_avatar_id.to_i     ## remember; maybe some validations will fail
    else
      params[:customer][:company_avatar] = nil
    end
  end

  def consume_avatar
    remove_temp_upload
  end
end
