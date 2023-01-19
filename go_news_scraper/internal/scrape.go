package internal

import (
	"fmt"
	"log"
	"os/exec"
	"strings"
	"time"

	"github.com/gocolly/colly/v2"
)

type News struct {
	Topic       string
	Title       string
	Article     string
	Description string
	Date        string
	Url         string
	ImgUrl      string
}

func ScrapeNews() []News {
	c := colly.NewCollector()
	newsCollector := c.Clone()
	textCollector := c.Clone()

	news := News{}
	newsArray := []News{}

	c.OnHTML("#top-navigation nav ul li a", func(e *colly.HTMLElement) {
		topic := e.Text
		url := e.Attr("href")
		news.Topic = topic
		newsCollector.Visit(e.Request.AbsoluteURL(url))
	})

	// Set a callback function for the HTML element matching the selector
	newsCollector.OnHTML("ol li article", func(e *colly.HTMLElement) {
		// Extract the title and url of the article
		title := e.ChildText("h3 a span")
		date := e.ChildText("time span.qa-post-auto-meta")
		dateString := parseTIme(date)
		url := e.ChildAttr("a", "href")
		// Print the title and url
		// fmt.Println(title, url)
		news.Title = title
		news.Date = dateString
		news.Url = url

		if len(date) <= 5 {
			textCollector.Visit(e.Request.AbsoluteURL(url))
		}
	})

	newsCollector.OnRequest(func(r *colly.Request) {
		log.Println("visiting", r.URL.String())
	})

	textCollector.OnHTML("article", func(h *colly.HTMLElement) {
		article := h.ChildText("p.ssrcss-1q0x1qg-Paragraph")
		imgUrl := h.ChildAttr("img", "src")
		news.Article = article
		news.Description = describe(article)
		news.ImgUrl = imgUrl
		newsArray = append(newsArray, news)
	})

	// textCollector.OnRequest(func(r *colly.Request) {
	// 	log.Println("visiting", r.URL.String())
	// })
	c.Visit("https://www.bbc.com/news")

	return newsArray
}

func parseTIme(articleTime string) string {
	articleTimeParts := splitTime(articleTime)
	timeNow := time.Now().UTC()
	year := fmt.Sprintf("%v", timeNow.Year())
	month := fmt.Sprintf("%d", timeNow.Month())
	if len(month) < 2 {
		month = "0" + month
	}
	day := fmt.Sprintf("%v", timeNow.Day())
	if len(day) < 2 {
		day = "0" + day
	}
	monthTable := map[string]string{
		"Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04", "May": "05", "Jun": "06", "Jul": "07", "Aug": "08", "Sep": "09", "Nov": "11", "Dec": "12",
	}
	if len(articleTimeParts) == 4 {
		t := year + "-" + monthTable[articleTimeParts[3]] + "-" + articleTimeParts[2] + " " + articleTimeParts[0] + ":" + articleTimeParts[1] + ":00.000Z"
		return t
	}
	t := year + "-" + month + "-" + day + " " + articleTimeParts[0] + ":" + articleTimeParts[1] + ":00.000Z"
	return t
}

func splitTime(time string) []string {
	splitFunc := func(r rune) bool {
		return r == ':' || r == ' '
	}

	parts := strings.FieldsFunc(time, splitFunc)
	for index, i := range parts {
		if len(i) < 2 {
			parts[index] = "0" + i
		}
	}

	return parts
}

func describe(article string) string {
	cmd := exec.Command("/opt/homebrew/bin/python3", "/Users/ghboo/go/src/github.com/Boo-Geonhyeok/news/python_summarization/summarization.py", article)
	output, err := cmd.Output()
	if err != nil {
		fmt.Println(err)
	}
	return string(output)
}
