require 'spec_helper'

RSpec.describe AutoHtml::YouTubeThumbnail do
  it 'transforms youtube url' do
    result = subject.call('http://www.youtube.com/watch?v=BwNrmYRiX_o')
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/BwNrmYRiX_o/0.jpg" /></div>'
  end

  it 'transforms youtube url with lot of params' do
    result = subject.call('http://www.youtube.com/watch?v=BwNrmYRiX_o&eurl=http%3A%2F%2Fvukajlija.com%2Fvideo%2Fklipovi%3Fstrana%3D6&feature=player_embedded') { youtube }
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/BwNrmYRiX_o/0.jpg" /></div>'
  end

  it 'transforms youtube url ignoring text' do
    result = subject.call('foo http://www.youtube.com/watch?v=fT1ahr81HLw bar') { youtube }
    expect(result).to eq 'foo <div class="thumbnail youtube"><img src="http://img.youtube.com/vi/fT1ahr81HLw/0.jpg" /></div> bar'
  end

  it 'transforms youtube url ignoring html tags' do
    result = subject.call('foo http://www.youtube.com/watch?v=fT1ahr81HLw<br>bar') { youtube }
    expect(result).to eq 'foo <div class="thumbnail youtube"><img src="http://img.youtube.com/vi/fT1ahr81HLw/0.jpg" /></div><br>bar'
  end

  it 'transforms url without www' do
    result = subject.call('http://youtube.com/watch?v=BwNrmYRiX_o') { youtube }
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/BwNrmYRiX_o/0.jpg" /></div>'
  end

  it 'transforms short url' do
    result = subject.call('http://www.youtu.be/BwNrmYRiX_o')
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/BwNrmYRiX_o/0.jpg" /></div>'
  end

  it 'transforms short url with params' do
    result = subject.call('http://youtu.be/t7NdBIA4zJg?t=1s&hd=1')
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/t7NdBIA4zJg/0.jpg" /></div>'
  end

  it 'transforms https url' do
    result = subject.call('https://www.youtube.com/watch?v=t7NdBIA4zJg')
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/t7NdBIA4zJg/0.jpg" /></div>'
  end

  it 'transforms url without protocol' do
    result = subject.call('www.youtube.com/watch?v=t7NdBIA4zJg')
    expect(result).to eq '<div class="thumbnail youtube"><img src="http://img.youtube.com/vi/t7NdBIA4zJg/0.jpg" /></div>'
  end
end
