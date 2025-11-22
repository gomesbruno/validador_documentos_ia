class HealthCheckController < ActionController::Base

  def teste_monitoramento
    begin
      text = ActiveRecord::Base.connected? ? 'UP' : 'DOWN'
    rescue
      text = 'DOWN'
    end
    render text: text
  end

  def teste_email
    raise 'Email test error'
  end

end
