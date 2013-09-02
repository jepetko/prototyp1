class CustomersController < ApplicationController

  include TemporaryUploadSupport

  before_filter :authenticate_user!

  # GET /customers
  # GET /customers.json
  def index
    keyword = params[:keyword]
    if keyword.nil?
      @customers = Customer.all
    else
      @customers = Customer.where("name LIKE '%#{keyword}%'")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
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
    customer_params = params[:customer]

    fill_company_avatar(customer_params)

    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save

        if not @customer.company_avatar.nil?
          remove_temp_upload
        end

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
    fill_company_avatar(customer_params)

    @customer = Customer.find(params[:id])

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

  def map
    respond_to do |format|
      format.html { redirect_to customers_url }
    end
  end

  private
  def fill_company_avatar(customer_params)
    company_avatar_id = customer_params[:company_avatar]

    if company_avatar_id.nil? || company_avatar_id.empty?
      customer_params[:company_avatar] = nil
    else
      company_avatar = CompanyAvatar.find_by_id( company_avatar_id.to_i )
      if not company_avatar.nil?
        remember_temp_upload company_avatar_id.to_i
      end
      customer_params[:company_avatar] = company_avatar
    end
  end
end
