require 'rubygems'
require 'sinatra'
require 'RMagick'

class String
  def self.random(length=6)
    ('a'..'z').sort_by {rand}[0,length].join
  end
end

enable :sessions

get '/' do
  doc = <<-DOC
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="ru-RU">
      <head profile="http://gmpg.org/xfn/11">
      <title>Каптча - тест</title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      </head>
      <body>
        <form action="/" method="post">
        <%= captcha_tag %>
        <br />
        <input type="submit" />
        </form>
      </body>
      </html>
  DOC
  erb doc
end

post '/' do
   doc = <<-DOC
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="ru-RU">
      <head profile="http://gmpg.org/xfn/11">
      <title>Каптча - тест</title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      </head>
      <body>
   DOC
   if(session[:captacha_text] == params[:captcha_text])
    doc << "<h2>Введён верный код, вы можете перейти к следующему шагу</h2>"
   else
     doc << "<h2 style=\"color:#FF0000\">Введён неверный код, вернитесь к предидущему шагу</h2>"
   end
   doc << <<-DOC
        <br />
        <a href="/" title="Назад">Назад</a>
      </body>
      </html>
   DOC
  erb doc
end

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

helpers do
  def captcha_tag
    "<table>
    <tr>
      <td><img src=\"/captcha\" alt=\"Код\"></td>
      <td>
        <input type=\"text\" name=\"captcha_text\" id=\"captcha_text\"><br />
        <span style=\"font-size:10px;\">Введите код с изображения</span>
      </td>
    </tr>
    </table>
    "
  end
end