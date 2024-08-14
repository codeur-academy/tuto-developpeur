# _plugins/next_prev_tag.rb
module Jekyll
    class NextPrevTag < Liquid::Tag

      def initialize(tag_name, text, tokens)
        super
      end
  
      def render(context)

        # # Obtenir la collection actuelle (à adapter en fonction de votre configuration)
        # collection = context.registers[:site].posts
  
        # # Obtenir l'élément courant (à adapter en fonction de votre implémentation)
        # current_item = context['page']
  
        # # Trouver l'index de l'élément courant dans la collection
        # index = collection.index(current_item)
  
        # # Vérifier si l'élément a un précédent ou un suivant
        # prev_item = index > 0 ? collection[index - 1] : nil
        # next_item = index < collection.length - 1 ? collection[index + 1] : nil
  
        # Rendre le résultat au format HTML (à personnaliser)
        # <<-HTML
        #   {% if prev_item %}
        #     <a href="{{ prev_item.url }}">Article précédent : {{ prev_item.title }}</a>
        #   {% endif %}
        #   {% if next_item %}
        #     <a href="{{ next_item.url }}">Article suivant : {{ next_item.title }}</a>
        #   {% endif %}
        # HTML

        <<-HTML
         <p>Page suivante</p>
        HTML
      end
    end
  end
Liquid::Template.register_tag('next_prev_tag ', Jekyll::NextPrevTag)