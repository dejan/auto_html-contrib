require 'spec_helper'
require 'fakeweb'

RSpec.describe AutoHtml::Twitter do
  before do
    response = %(
      {
        "author_name": "Dan Martell",
        "author_url": "https://twitter.com/danmartell",
        "cache_age": "3153600000",
        "height": null,
        "html": "things",
        "provider_name": "Twitter",
        "provider_url": "https://twitter.com",
        "type": "rich",
        "url": "https://twitter.com/danmartell/statuses/279651488517738496",
        "version": "1.0",
        "width": 550
    })

    FakeWeb.register_uri(:get, %r{https://api\.twitter\.com/1/statuses/oembed\.json}, body: response)
  end

  it 'transforms' do
    transformed_html = 'things'
    result = subject.call('https://twitter.com/danmartell/statuses/279651488517738496')
    expect(result).to eq transformed_html
  end

  it 'test_dont_transform_a_regular_link_to_twitter' do
    transformed_html = '<blockquote class="twitter-tweet"><p>Stop saying you can&#39;t! Start asking &quot;What would need to be true for me to accomplish this&quot; - it&#39;ll change your life. <a href="https://twitter.com/search?q=%23focus&amp;src=hash">#focus</a> <a href="https://twitter.com/search?q=%23solutions&amp;src=hash">#solutions</a></p>&mdash; Dan Martell (@danmartell) <a href="https://twitter.com/danmartell/statuses/279651488517738496">December 14, 2012</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>'
    result = subject.call(transformed_html)

    expect(result).to eq transformed_html
  end
end
