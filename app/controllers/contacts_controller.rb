class ContactsController < ApplicationController

  # GET /contacts
  # GET /contacts.json
  def index
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
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # GET /contacts/edit
  def edit_all
    @contacts = Contact.where( :customer_id => params[:customer_id])

    respond_to do |format|
      format.js { }
      format.json { render json: @contacts }
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create

    customer = Customer.find(params[:customer_id])
    @contact = customer.contacts.create( params[:contact] )

    respond_to do |format|
      if @contact.save

        format.html { redirect_to customer_contacts_path(customer), notice: 'Contact was successfully created.' }
        format.js { }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
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
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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

  def index_paginated
    @contacts = Contact.where( :customer_id => params[:customer_id])

    render :partial => 'contacts/pageable_contacts', :locals => { :contacts => @contacts }
  end
end
