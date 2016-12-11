package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

//=========================================================================================
func main() {
	// two different ways to execute an http.GET
	doGet("http://cnn.com/")
	fmt.Println("")
	doGetClient("http://cnn.com/")
	/**
	 * this does an minimal http.PUT
	 * you might have to add a "Content-Type: some value"
	 * to the request header if you put to a different system
	 * or put a different file type
	 **/
	// replace this url with your PUT enabled restful web server
	doPut("http://localhost:8080/exist/rest/db/eric/golang.xml")
	/** for reference the url above is for an exist-db instance
	 *  to find out more visit http://exist-db.org/
	 **/

}

//=========================================================================================
func doGet(url string) {
	response, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	} else {
		defer response.Body.Close()
		contents, err := ioutil.ReadAll(response.Body)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("The calculated length is:", len(string(contents)), "for the url:", url)
		fmt.Println("   ", response.StatusCode)
		hdr := response.Header
		for key, value := range hdr {
			fmt.Println("   ", key, ":", value)
		}
	}
}

//=========================================================================================
func doGetClient(url string) {
	client := &http.Client{}

	response, err := client.Get(url)
	if err != nil {
		log.Fatal(err)
	} else {
		defer response.Body.Close()
		contents, err := ioutil.ReadAll(response.Body)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("The calculated length is:", len(string(contents)), "for the url:", url)
		fmt.Println("   ", response.StatusCode)
		hdr := response.Header
		for key, value := range hdr {
			fmt.Println("   ", key, ":", value)
		}
	}
}

//=========================================================================================
func doPut(url string) {
	client := &http.Client{}
	request, err := http.NewRequest("PUT", url, strings.NewReader("<golang>really</golang>"))
	request.SetBasicAuth("admin", "admin")
	request.ContentLength = 23
	response, err := client.Do(request)
	if err != nil {
		log.Fatal(err)
	} else {
		defer response.Body.Close()
		contents, err := ioutil.ReadAll(response.Body)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("The calculated length is:", len(string(contents)), "for the url:", url)
		fmt.Println("   ", response.StatusCode)
		hdr := response.Header
		for key, value := range hdr {
			fmt.Println("   ", key, ":", value)
		}
		fmt.Println(contents)
	}
}
