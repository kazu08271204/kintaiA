class UsersController < ApplicationController

  #controllerでbefore_actionを定義することで、アクションの前に処理を差し込むことができ
  before_action :set_user, only: [:show, :edit, :update, :destroy]
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy] 
    #index,show,edit,updateアクションが実行される直前のみ、logged_in_userが実行
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :edit, :destroy, :edit_basic_info, :update_basic_info]
 
  before_action :set_one_month, only: [:show]
  before_action :admin_or_correct_user, only: [:show]
  before_action :no_admin_user, only: [:show]
  
  def index
     @users = User.where.not(id: current_user.id)
     #@users = User.all
  end
  
  
  
  def show
   
    @worked_sum = @attendances.where.not(started_at: nil).count
    #1ヶ月分の勤怠データの中で、出勤時間が何も無い状態では無いものの数を代入
  end
  
  
  
  def new
    @user = User.new  # ユーザーオブジェクトを生成し、インスタンス変数に代入します。
  end
  
  def create
    @user = User.new(user_params)# 保存成功後、ログインします。
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = "新規作成に成功しました。"
       redirect_to @user #=redirect_to user_url(@user)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデーターを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end

  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user   
    else
      render 'edit_basic_info'
    end
  end
  
  
  def attendance_list
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation) #更新に対応するためのStrongParameters
  end
  
  def basic_info_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation) #更新に対応するためのStrongParameters
  end
  
  
  def query
    if params[:user].present? && params[:user][:name]
      User.where('LOWER(name) LIKE ?', "%#{params[:user][:name].downcase}%")
    else
      User.all
    end
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "権限がありません。"
        redirect_to(root_url)
      end  
    end
  
end 




