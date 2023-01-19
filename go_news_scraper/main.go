package main

import (
	"encoding/json"
	"io/ioutil"

	"github.com/Boo-Geonhyeok/news/go_news_scraper/internal"
)

func main() {
	news := internal.ScrapeNews()
	rankingsJson, _ := json.Marshal(news)
	ioutil.WriteFile("output.json", rankingsJson, 0644)
}
