module ChapitreGenerator
    class MyPageGenerator < Jekyll::Generator

      def chapter_exists_by_reference?(site, reference)
        # Access chapters using site.collections["chapitres"].docs
        chapters = site.collections["chapitres"].docs
        
        # Use `any?` with a corrected condition
        chapters.any? { 
          |chapter| 
          chapter.data.key?("reference") && chapter.data["reference"] == reference }
      end


      def generate(site)

        # Generation de chapitre s'il n'existe pas dans la collections chapitres

        # if self.chapter_exists_by_reference?(site,"Introduction")
        #   puts "Chapitre introduction existe"
        # end


        dir = '.'
        chapitres = site.data["chapitres"] || {}

        chapitres.each do |chapitre|

            reference =  chapitre["reference"]

            if self.chapter_exists_by_reference?(site,reference)
              # puts reference + " existe"
              next
            end 

            # puts reference
            name = reference + ".html"
            site.pages << Jekyll::PageWithoutAFile.new(site, site.source, dir, name).tap do |file|
                file.content = chapitre["titre_francais"]
                file.data.merge!(
                    "layout"     => "home",
                    "sitemap"    => false,
                )
                file.output
            end

        end

      end
    end
  end