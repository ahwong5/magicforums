module FlashMessagesHelper

  def display_message(value)
    #return if it is not an array
    return content_tag(:p, value) unless value.kind_of?(Array)
    #if it is an array, return the contents with a class list
    content_tag :ul do
      value.collect { |message| content_tag(:li, message, class: 'list-styling') }.join.html_safe
    end
  end
end
