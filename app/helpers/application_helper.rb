module ApplicationHelper
  def get_satisfaction_widget
    return unless Rails.env.production?
    raw <<-EOC
      <script type="text/javascript" charset="utf-8">
        var is_ssl = ("https:" == document.location.protocol);
        var asset_host = is_ssl ? "https://s3.amazonaws.com/getsatisfaction.com/" : "http://s3.amazonaws.com/getsatisfaction.com/";
        document.write(unescape("%3Cscript src='" + asset_host + "javascripts/feedback-v2.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript" charset="utf-8">
        var feedback_widget_options = {};
        feedback_widget_options.display = "overlay";
        feedback_widget_options.company = "oneclickorgs";
        feedback_widget_options.placement = "left";
        feedback_widget_options.color = "#222";
        feedback_widget_options.style = "idea";
        var feedback_widget = new GSFN.feedback_widget(feedback_widget_options);
      </script>
    EOC
  end

  def google_analytics_code
    return unless Rails.env.production? && OneClickOrgs::GoogleAnalytics.active?
    analytics_js = <<-EOC
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '#{OneClickOrgs::GoogleAnalytics.id}']);
      _gaq.push(['_setDomainName', '#{OneClickOrgs::GoogleAnalytics.domain}']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    EOC
    unless @analytics_events.blank?
      analytics_js += @analytics_events.map do |event|
        "OneClickOrgs.trackAnalyticsEvent('#{event}');"
      end.join("\n")
    end
    ['<script type="text/javascript">', analytics_js, '</script>'].join("\n").html_safe
  end

  def error_messages_for(object)
    messages = object.errors.full_messages.map do |message|
      content_tag(:li, message)
    end.join
    content_tag(:ul, messages.html_safe, :class => 'errors')
  end

  def organisation_name
    current_organisation.try(:name)
  end

  def form_reveal_button(label, options={})
    options = options.with_indifferent_access

    form_id = options.delete(:form_id)
    raise RuntimeError, "must specify form_id" if form_id.blank?
    options['data-form-id'] = form_id

    css_class = if options[:class].present?
      options[:class] + ' button-form-show'
    else
      'button-form-show'
    end
    options[:class] = css_class

    options[:value] = label

    options[:type] = 'button'

    tag(:input, options)
  end

  def link_button(label, options={})
    options = options.with_indifferent_access

    url = options.delete(:url)
    raise RuntimeError, "must specify url" if url.blank?
    options['data-url'] = url

    css_class = if options[:class].present?
      options[:class] + ' button-form'
    else
      'button-form'
    end
    options[:class] = css_class

    options[:value] = label

    options[:type] = 'button'

    tag(:input, options)
  end

  def new_child_fields_template(form_builder, association, options={})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= "#{options[:partial]}_fields".to_sym

    content_tag(:div, :class => "#{association}_fields_template", :style => 'display: none;') do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => {(options[:form_builder_local]) => f})
      end
    end
  end

  # Returns a string describing how many (whole) months ago the given time was.
  def months_ago_in_words(from_time)
    distance_in_months = (Time.now.utc - from_time.to_time) / (1.month)
    distance_in_months = distance_in_months.floor
    pluralize(distance_in_months, 'month')
  end
end
