class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:orders).order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      # Create an outgoing record to send via JSON-RPC
      OutgoingRecord.create!(
        record_type: 'user',
        data: @user.to_json_rpc_data
      )
      
      redirect_to @user, notice: 'User was successfully created and queued for sending.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      # Create an outgoing record for the update
      OutgoingRecord.create!(
        record_type: 'user_update',
        data: @user.to_json_rpc_data.merge(action: 'update')
      )
      
      redirect_to @user, notice: 'User was successfully updated and queued for sending.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :age)
  end
end
