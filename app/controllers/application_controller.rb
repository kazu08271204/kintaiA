class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #どのコントローラでもヘルパーに定義したメソッドが使える
  include AttendancesHelper
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
   # beforeフィルター
   
  def set_user
    @user = User.find(params[:id])
     # paramsハッシュからユーザーを取得します。
  end


   # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?# unless ~ end 条件式がfalseの時、処理が実行される構文
      store_location
      flash[:danger] = "ログインしてください。"# :danger→赤色 
      redirect_to login_url 
    end
  end 
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定します。
  #管理者でなければredirect
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  #システム管理権限所有者はredirect
  def no_admin_user
    if current_user.admin?
    redirect_to root_url
    end
  end
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    #対象の月の日数を代入
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    #ユーザーに紐づく一か月のレコードを検索し取得します。worked_onの値をもとに昇順に並び替え
    
    #unless文は条件式がfalseと評価された場合のみ内部の処理を実行
    
    unless one_month.count == @attendances.count
    #1ヶ月分の日付の件数と勤怠データの件数(日数)が一致するか評価します。
      ActiveRecord::Base.transaction do
      #トランザクションを開始します。
      #(指定したブロックにあるデータベースへの操作が全部成功することを保証する為の機能)
        one_month.each { |day| @user.attendances.create!(worked_on: day)}
        #繰り返し処理により一か月分の勤怠データを生成します。
      end
       @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
    
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url  
    
  end

end

