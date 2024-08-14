# _plugins/custom_tag.rb
module Jekyll
    class NextChapterTag < Liquid::Tag

      # param : text
      def initialize(tag_name, text, tokens)
        super
        @text = text.strip
      end
  
      def render(context)

        # # chaque élément site.collections est un tableau de deux élément : 0 : label, 1 : collection
        # chapters_collection  = context.registers[:site].collections.detect { |collection| collection[0] == "chapters" }[1].docs


       
        # current_item = context['page']
  
        #   chapters_collection
        # pp current_item["next"]
        # pp current_item["previous"]

        # index = collection.index(current_item)
  
        # # Vérifier si l'élément a un précédent ou un suivant
        # prev_item = index > 0 ? collection[index - 1] : nil
        # next_item = index < collection.length - 1 ? collection[index + 1] : nil
        "next"
  
        # <<-HTML
        #   {% if prev_item %}
        #     <a href="{{ prev_item.url }}">Article précédent : {{ prev_item.title }}</a>
        #   {% endif %}
        #   {% if next_item %}
        #     <a href="{{ next_item.url }}">Article suivant : {{ next_item.title }}</a>
        #   {% endif %}
        # HTML
      end
    end
  end
  
  Liquid::Template.register_tag('new_chapter_tag', Jekyll::NextChapterTag)