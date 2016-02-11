
# 必要なgemを読み込み。読み込み方やその意味はrubyの基本をおさらいして下さい。
require 'nokogiri'
require 'anemone'

# 後述。
opts = {
    depth_limit: 0
}
# AnemoneにクロールさせたいURLと設定を指定した上でクローラーを起動！
Anemone.crawl("http://gigazine.net/", opts) do |anemone|
  # 指定したページのあらゆる情報(urlやhtmlなど)をゲットします。
  anemone.on_every_page do |page|

    # page.docでnokogiriインスタンスを取得し、xpathで欲しい要素(ノード)を絞り込む
    #page.doc.xpath("/html/body//section[@class='content']/div[contains(@class,'contentBody')]//li[contains(@class,'videoRanking')]/div[@class='itemContent']").each do |node|
    page.doc.xpath("/html/body/div//div[@class='box']").each do |node|

      # 更に絞り込んでstring型に変換
      title = node.xpath("./h2/a/text()").to_s
      title2 = node.xpath("./div[@class='boxgrid caption']/div[@class='wideimg']//img").attribute("src")
      title3 = node.xpath("./div[@class='boxgrid caption']/div[@class='wideimg']//img").attribute("data-original")
       #puts node.css('a').attribute('href').value
       #puts node.css('img').attribute('src')
       # 更に絞り込んでstring型に変換
      #viewCount = node.xpath("./div[@class='itemData']//li[contains(@class,'view')]/span/text()").to_s

      # 表示形式に整形
      puts title
      puts title2
      puts title3

      puts "\n-----------------------------------------------\n"
    end # node終わり
  end # page終わり
end # Anemone終わり
