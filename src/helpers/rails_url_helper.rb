
# Url helpers
# http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html
module RailsUrlHelper

  BOOLEAN_ATTRIBUTES = %w(disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seemless muted required
                       autofocus novalidate formnovalidate open).to_set
  BOOLEAN_ATTRIBUTES.merge(BOOLEAN_ATTRIBUTES.map {|attr| attr.to_sym })

  def link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      link_to(capture_haml(&block), options, html_options)
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2]

      url = url_for(options)
      tag_options = tag_options(html_options)

      href_attr = "href=\"#{html_escape(url)}\""
      "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>"
    end
  end

  # Only support hexadecimal encoding
  def mail_to(email_address, name = nil, html_options = {})
    email_address = html_escape(email_address)

    html_options = html_options.stringify_keys
    encode = html_options.delete("encode").to_s
    cc, bcc, subject, body = html_options.delete("cc"), html_options.delete("bcc"), html_options.delete("subject"), html_options.delete("body")

    extras = []
    extras << "cc=#{Rack::Utils.escape(cc).gsub("+", "%20")}" unless cc.nil?
    extras << "bcc=#{Rack::Utils.escape(bcc).gsub("+", "%20")}" unless bcc.nil?
    extras << "body=#{Rack::Utils.escape(body).gsub("+", "%20")}" unless body.nil?
    extras << "subject=#{Rack::Utils.escape(subject).gsub("+", "%20")}" unless subject.nil?
    extras = extras.empty? ? '' : '?' + html_escape(extras.join('&'))

    email_address_obfuscated = email_address.to_str
    email_address_obfuscated.gsub!(/@/, html_options.delete("replace_at")) if html_options.has_key?("replace_at")
    email_address_obfuscated.gsub!(/\./, html_options.delete("replace_dot")) if html_options.has_key?("replace_dot")

    string = ''

    if encode == "hex"
      email_address_encoded = ''
      email_address_obfuscated.each_byte do |c|
        email_address_encoded << sprintf("&#%d;", c)
      end

      protocol = 'mailto:'
      protocol.each_byte { |c| string << sprintf("&#%d;", c) }

      email_address.each_byte do |c|
        char = c.chr
        string << (char =~ /\w/ ? sprintf("%%%x", c) : char)
      end

      "<a href=\"#{string}#{extras}\"#{tag_options(html_options)}>#{html_escape(name || email_address_encoded)}</a>"
    else
      "<a href=\"mailto:#{email_address}#{extras}\"#{tag_options(html_options)}>#{html_escape(name || email_address_obfuscated)}</a>"
    end
  end

  # Only support string and :back options
  # If a string is given, will try to resolv it to a page url with page_find
  def url_for(options = {})
    url = if options == :back
      'javascript:history.back()'
    elsif options.kind_of?(String) and respond_to?(:page_find) and path = page_find(options)
      path
    elsif options.kind_of?(String)
      options
    else
      '#'
    end
  end

  private

    def tag_options(options, escape = true)
      unless options.nil? or options.empty?
        attrs = []
        options.each_pair do |key, value|
          if BOOLEAN_ATTRIBUTES.include?(key)
            attrs << %(#{key}="#{key}") if value
          elsif !value.nil?
            final_value = value.is_a?(Array) ? value.join(" ") : value
            final_value = html_escape(final_value) if escape
            attrs << %(#{key}="#{final_value}")
          end
        end
        " #{attrs.sort * ' '}".html_safe unless attrs.empty?
      end
    end

end