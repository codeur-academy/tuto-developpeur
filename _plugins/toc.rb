
# donner le code ruby d'un plugin jekyll qui permet d'afficher la table de
# matière d'une collection


module JekyllTocPlugin
  class TocGenerator < Jekyll::Generator
    def generate(site)
    #   toc_html = generate_toc_html(site.site_content)

        toc_html = "<h1>Table de matière</h1>"
        page.data['toc'] = toc_html

        file.data.merge!(
            "layout"     => "chapitre_autoformation",
            "title" => chapitre["title"] ,
            "sitemap"    => false,
        )


    end

    private

    def generate_toc_html(site_content)
      headings = extract_headings(site_content)
      toc_html = '<ul class="toc">'
      headings.each do |heading|
        toc_html += "<li><a href=\"#{heading[:href]}\">#{heading[:text]}</a></li>"
      end
      toc_html += '</ul>'

      toc_html
    end

    def extract_headings(site_content)
      headings = []

      site_content.scan(/<h(\d+)>(.*?)<\/h\1>/m) do |level, text|
        text = text.strip
        href = "#" + text.downcase.gsub(/[^\w-]/, '-')

        headings << {
          level: level.to_i,
          text: text,
          href: href
        }
      end

      headings.sort_by do |heading|
        heading[:level]
      end
    end
  end
end