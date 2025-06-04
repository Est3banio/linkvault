# frozen_string_literal: true

# Mailer for password reset functionality
class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: t('mailers.passwords.reset_subject'), to: user.email_address
  end
end
