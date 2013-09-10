class ContactsController < ApplicationController

  before_filter :authenticate_user!

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.where( :customer_id => params[:customer_id])

    respond_to do |format|
      format.js { }
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/edit_all
  def edit_all
    @contacts = Contact.where( :customer_id => params[:customer_id])

    respond_to do |format|
      format.js { }
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.js { }
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end



  # POST /contacts
  # POST /contacts.json
  def create

    customer = Customer.find(params[:customer_id])
    @contact = customer.contacts.create( params[:contact] )

    respond_to do |format|
      if @contact.save
        format.js { }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.js { }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.js { }
        format.json { head :no_content }
      else
        format.js { }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to edit_customer_path(@contact.customer) }
      format.json { head :no_content }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  def form
    customer_id = params[:customer_id]
    customer = Customer.where(:id => customer_id).first
    @contact = params.has_key?(:id) ? customer.contacts.where(:id => params[:id]).first : customer.contacts.build

    respond_to do |format|
      format.js { }
      format.json { render json: @contact }
    end
  end
end
