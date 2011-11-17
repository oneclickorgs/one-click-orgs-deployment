require 'one_click_orgs/mail_helper'

class OcoMailer < ActionMailer::Base
  helper :application
  include ActionView::Helpers::TextHelper
  include OneClickOrgs::MailHelper
  default :from => "notifications@oneclickorgs.com"

  class EmailJob
    attr_reader :mail

    def initialize(mail)
      @mail = mail.encoded
    end

    def perform
      message = Mail::Message.new(mail)
      ActionMailer::Base.wrap_delivery_behavior(message)
      message.deliver!
    end
  end

  # Helper method to create email according to the following conventions:
  # * the sender is an OCO address, but is given the name of the current org
  # * there is one recipient
  # * the subject line will be truncated to 200 chars max, and any newlines will be stripped
  def create_mail(from_name, to, subject)
    mail(
      :from => name_addr(from_name, 'notifications@oneclickorgs.com'),
      :to => to, 
      :subject => truncate(subject, {:length => 200}).gsub(/[\r\n]+/, ' '))
  end

  def self.deliver_mail(mail)
    if !Rails.env.test? && worker_running?
      Delayed::Job.enqueue EmailJob.new(mail)
    else
      Rails.logger.debug "Worker not running, falling back to direct sending"
      super
    end
  end

  def self.worker_running?
    pid_file = File.join(Rails.root, 'tmp', 'pids', 'delayed_job.pid')
    return false unless File.exist? pid_file
    pid = IO.read(pid_file).strip.to_i
    begin
      !!Process.kill(0, pid)
    rescue Errno::ESRCH
      false
    end
  end
end
