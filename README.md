This is source code for my post about dynamic captcha image in sinatra and rails application.
Main idea is simple. I'm using rmagick to create dynamic image with random text and write it to response,
captcha text is stored in session. 

**Code for the sinatra app:**

```ruby
get '/captcha/?' do
  text = String.random(4)
  session[:captacha_text] = text
  captcha = Magick::Image.new(125, 75)
  captcha.format = 'JPEG'
  captcha_text = Magick::Draw.new
  captcha_text.annotate(captcha, 0, 0, 0, 0, text) do |ct|
      ct.font = 'Helvetica'
      ct.pointsize = 56
      ct.font_weight = Magick::BoldWeight
      ct.gravity = Magick::SouthEastGravity
  end
  captcha = captcha.wave(2.5, 70)
  content_type :jpeg  
  captcha.to_blob
end
```

**Code that can be used in rails app:**

```ruby
def show    
    text = String.random(4)
    session[:captcha_text] = text
    capcha_image = Image.new(85, 30)
    capcha_image.format = 'JPEG'
    captcha_text = Magick::Draw.new
    captcha_text.annotate(capcha_image, 0, 0, 0, 2, text) do
      self.font = 'Helvetica'
      self.pointsize = 22
      self.font_weight = Magick::BoldWeight      
      self.gravity = Magick::CenterGravity
    end
    capcha_image = capcha_image.wave(2.5, 70)

    send_data capcha_image.to_blob, :type => 'image/jpeg', :disposition => 'inline'
end
```
The example app writen in sinatra. More detailed explanation of this code in russian is my post.
