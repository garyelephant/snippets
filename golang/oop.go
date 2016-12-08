// This is a good example of golang way to implement inheritance and polymorphism
// for oop.

package main

import "fmt"

type Parent struct {
	Attr1 string
}

type Parenter interface {
	GetParent() Parent
}

type Child struct {
	Parent //embed
	Attr   string
}

func (c Child) GetParent() Parent {
	return c.Parent
}

func setf(p Parenter) {
	fmt.Println(p)
}

func main() {
	var ch Child
	ch.Attr = "1"
	ch.Attr1 = "2"

	setf(ch)
}
