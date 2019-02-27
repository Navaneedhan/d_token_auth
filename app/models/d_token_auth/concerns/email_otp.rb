module DTokenAuth::Concerns::EmailOtp
  extend ActiveSupport::Concern
  def trigger_otp!(requested_at, force: false)
    if self.encrypted_otp.nil? || is_otp_expired? || force
      otp_string_part = generate_otp_string
      otp = generate_otp
      encrypted_otp = password_digest(otp)
      self.update!(otp_string: otp_string_part, encrypted_otp: encrypted_otp, otp_expire_at: requested_at + 10.minutes, uid: self.email)
      # NotificationService.notify_otp(self, requested_at, "#{otp_string_part}-#{otp}")
    end
  end

  def verify_otp?(otp_numeric)
    return false if encrypted_otp.nil?
    if (failed_otp_attempts < Settings.devise.failed_attempts) && valid_otp?(otp_numeric) && otp_expire_at.future?
      true
    else
      self.increment!(:failed_otp_attempts)
      self.update!(last_failed_attempt_at: Time.current) if self.respond_to?(:last_failed_attempt_at)
      false
    end
  end

  def reset_otp!
    self.update!(encrypted_otp: nil, otp_string: nil, failed_otp_attempts: 0)
  end

  def generate_otp_string
    (0...3).map { (65 + rand(26)).chr }.join
  end

  def generate_otp
    (0...6).map { rand(9) }.join
  end

  def valid_otp?(otp)
    Devise::Encryptor.compare(self.class, encrypted_otp, otp)
  end

  def is_otp_expired?
    (self.otp_expire_at - 10.seconds).past?
  end
end
  