# frozen_string_literal: true

class ReferralToken::Generate < ReferralToken
  def call
    self.token = generate_unique_token
    save
    self
  end

  private

  def generate_unique_token
    loop do
      token = SecureRandom.hex(4).upcase
      break token unless self.class.exists?(token: token)
    end
  end
end
