class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    # To Initialiase
    @user = User.new
  end


  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You've successfully created an account"
      redirect_to topics_path
    else
      flash[:danger] = @user.errors.full_messages
      render :new
    end
  end


  def edit
    @user = User.find_by(id: params[:id])
    # authorize @user
  end


  def update
    @user = User.find_by(id: params[:id])
    authorize @user

    if @user.update(user_params)
      flash[:success] = "You've successfully edited your account"
      redirect_to topics_path
    else
      flash[:danger] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :image)
  end


end
