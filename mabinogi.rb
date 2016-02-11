require 'nokogiri'
require 'anemone'
require 'mysql2'

# 後述。
opts = {
  depth_limit: 0
}

# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl("http://heroes.nexon.co.jp/community/trade.aspx", opts) do |anemone|
  # 指定したページのあらゆる情報(urlやhtmlなど)をゲットします。
  anemone.on_every_page do |page|

    # page.docでnokogiriインスタンスを取得し、xpathで欲しい要素(ノード)を絞り込む
    #page.doc.xpath("/html/body//section[@class='content']/div[contains(@class,'contentBody')]//li[contains(@class,'videoRanking')]/div[@class='itemContent']").each do |node|
    #page.doc.xpath("/html/body/div//div[@class='box']").each do |node|

    #page.doc.xpath("/html/body/form/div[@class='container']//td[@class='td-title']").each do |node|
    page.doc.xpath("/html/body/form/div[@class='container']//tr").each do |node|

      # 更に絞り込んでstring型に変換
      title = node.xpath("./td[@class='td-title']/p/a/text()").to_s
      link = node.xpath("./td[@class='td-title']/p/a/@href").to_s
      img = node.xpath("./td[@class='td-title']/strong/text()").to_s

      user = node.xpath("./td[@class='td-writer']/p/text()").to_s
      view = node.xpath("./td[@class='td-view']/text()").to_s


      #title2 = node.xpath("./div[@class='boxgrid caption']/div[@class='wideimg']//img").attribute("src")
      #title3 = node.xpath("./div[@class='boxgrid caption']/div[@class='wideimg']//img").attribute("data-original")
       #puts node.css('a').attribute('href').value
       #puts node.css('img').attribute('src')
       # 更に絞り込んでstring型に変換
      #viewCount = node.xpath("./div[@class='itemData']//li[contains(@class,'view')]/span/text()").to_s

      # 表示形式に整形
      puts title
      puts link

      img.strip!
      puts img

      puts user
      puts view

      puts "\n-----------------------------------------------\n"
 

      client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => '')
      query = "select exists (select * from note.notes where title='#{title}' and link='#{link}')"
      results=client.query(query)


results.each do |row|
  row.each do |key, value|
    if (value == 0) then
      puts "oioi ! data ga naizo! kora"
      query = "insert into note.notes(title,link,img,user,view) values('#{title}','#{link}','#{img}','#{user}','#{view}')"
      client.query(query)
    end
  end
end

      query2 = "update note.notes set view = '#{view}' where link='#{link}'"
      client.query(query2)
      query3 = "update note.notes set img = '#{img}' where link='#{link}'"
      client.query(query3)


    end # node終わり
  end # page終わり
end # Anemone終わり
