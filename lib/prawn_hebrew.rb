require 'prawn'
#require_relative 'version'

module PrawnHebrew
  module Text
    DEFAULT_HEBREW_FONT = 'GveretLevinHebrew'.freeze
    DEFAULT_ENGLISH_FONT = 'Arial'.freeze

    # Returns array of text fragments for Prawn's formatted_text methods
    # Example:
    #   formatted_text_box hebrew_formatted_text('שלום world'), at: [0,100]
    def hebrew_formatted_text(text, size: 12, style: :normal, hebrew_font: DEFAULT_HEBREW_FONT, english_font: DEFAULT_ENGLISH_FONT)
      words = text.to_s.split(/(\s+|\n)/)
      hebrew_run = []
      fragments = []

      words.each do |word|
        if word.strip.empty?
          fragments << { text: word, font: english_font, size: size, style: style } if word != ' '
          next
        end

        if word =~ /\p{Hebrew}/
          hebrew_run << word
        else
          unless hebrew_run.empty?
            hebrew_run.reverse.each_with_index do |hw, idx|
              fragments << { text: hw, font: hebrew_font, size: size, direction: :rtl, style: style }
              fragments << { text: ' ', font: hebrew_font, size: size, direction: :rtl, style: style } if idx < hebrew_run.length - 1
            end
            fragments << { text: ' ' }
            hebrew_run.clear
          end
          fragments << { text: "#{word} ", font: english_font, size: size, style: style }
        end
      end

      unless hebrew_run.empty?
        hebrew_run.reverse.each_with_index do |hw, idx|
          fragments << { text: hw, font: hebrew_font, size: size, direction: :rtl, style: style }
          fragments << { text: ' ', font: hebrew_font, size: size, direction: :rtl, style: style } if idx < hebrew_run.length - 1
        end
      end

      fragments
    end

    # Helper combining hebrew_formatted_text with formatted_text_box
    def hebrew_text_box(text, **options)
      box_opts = options.dup
      box_opts.delete(:hebrew_font)
      box_opts.delete(:english_font)
      fragments = hebrew_formatted_text(text, **options)
      formatted_text_box(fragments, box_opts)
    end
  end
end

Prawn::Document.include PrawnHebrew::Text