# PrawnHebrew

A lightweight helper for rendering Hebrew and mixed Hebrew/English text in Prawn PDFs. It exposes helper methods that split text into fragments with correct fonts and direction so it can be passed directly to `formatted_text` or `formatted_text_box`.

## Usage

```ruby
require 'prawn_hebrew'

Prawn::Document.generate('example.pdf') do
  hebrew_text_box 'שלום world', at: [0, cursor], width: 200
end
```

`hebrew_text_box` accepts the same options as `formatted_text_box` along with `hebrew_font` and `english_font`.