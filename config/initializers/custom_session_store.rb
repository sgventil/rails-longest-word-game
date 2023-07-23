class ActionDispatch::Session::CookieStore < ActionDispatch::Session::AbstractSecureStore
  def initialize(app, options = {})
    super(app, options)
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    session = request.session

    if session[:scores].is_a?(Array) && session[:scores].any? { |score| score.is_a?(Integer) }
      total_score = session[:scores].sum
      session[:total_score] = total_score
    end
    super
  end
end
