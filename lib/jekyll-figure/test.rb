require 'jekyll'
require 'kramdown'

module Jekyll
  class CaptionBlock < Liquid::Block
    SYNTAX = /^\s*(below)\s*$/i

    def initialize(tag_name, markup, tokens)
      super
    end

    def split_content(content)
      parts = content.split(/<!--\s*caption below\s*-->/i, 2)
      upper = parts[0].strip
      lower = parts[1] ? parts[1].strip : ''
      return upper, lower
    end

    def render(context)
      content = super
      upper_md, lower_md = split_content(content)

      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      upper_html = converter.convert(upper_md)
      lower_html = converter.convert(lower_md)

      <<~HTML
      <figure class="captioned">
        #{upper_html}
        <figcaption>
          #{lower_html}
        </figcaption>
      </figure>
      HTML
    end
  end
end

Liquid::Template.register_tag('caption', Jekyll::CaptionBlock)
