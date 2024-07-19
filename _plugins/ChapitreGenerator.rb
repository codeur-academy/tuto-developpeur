module ChapterGenerator
    class MyPageGenerator < Jekyll::Generator

      def chapter_exists_by_reference?(site, reference)
        # Access chapters using site.collections["chapters"].docs
        chapters = site.collections["chapters"].docs
        
        # Use `any?` with a corrected condition
        chapters.any? { 
          |chapter| 
          chapter.data.key?("reference") && chapter.data["reference"] == reference }
      end


      def generate(site)

        # Generation de chapter s'il n'existe pas dans la collections chapters

        # if self.chapter_exists_by_reference?(site,"Introduction")
        #   puts "Chapter introduction existe"
        # end


        dir = '.'
        chapters = site.data["apprendre-html"] || {}

        chapters.each do |chapter|

            reference =  chapter["reference"]

            if self.chapter_exists_by_reference?(site,reference)
              # puts reference + " existe"
              next
            end 

            # puts reference
            name = reference + ".html"
            site.pages << Jekyll::PageWithoutAFile.new(site, site.source, dir, name).tap do |file|
                file.content = chapter["title"]

                file.data.merge!(
                    "layout"     => "chapter_autoformation",
                    "title" => chapter["title"] ,
                    "sitemap"    => false,
                )
                file.output
            end

        end

      end
    end
  end