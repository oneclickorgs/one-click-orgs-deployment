require 'one_click_orgs/mail_helper'

class OcoMailer < ActionMailer::Base
  helper :application
  include ActionView::Helpers::TextHelper
  include OneClickOrgs::MailHelper
  default :from => "no-reply@oneclickorgs.com"

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
  # * the sender is One Click Orgs
  # * there is one recipient
  # * invalid characters will be stripped from the subject line
  # * the subject line will be truncated to 200 chars max
  # * the organisation name will be included in the subject
  def create_mail(organisation_name, to, subject)
    subject = "[#{organisation_name}] #{subject}"
    subject = cleaned_subject(subject)
    subject = truncate(subject, {:length => 200})

    mail(
      :from => name_addr("One Click Orgs", 'no-reply@oneclickorgs.com'),
      :to => to, 
      :subject => subject
    )
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
