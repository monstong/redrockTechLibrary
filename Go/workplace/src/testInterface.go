package main

import "fmt"

type Coster interface {
	Cost() float64
}

func displayCost(c Coster) {
	fmt.Println("Cost: ", c.Cost())
}

type Item struct {
	name     string
	price    float64
	quantity int
}

func (t Item) Cost() float64 {
	return t.price * float64(t.quantity)
}

type DiscountItem struct {
	Item
	discountRate float64
}

func (t DiscountItem) Cost() float64 {
	return t.Item.Cost() * (1.0 - t.discountRate/100)
}

type Rental struct {
	name         string
	feePerDay    float64
	periodLength int
	RentalPeriod
}

type RentalPeriod int

const (
	Days RentalPeriod = iota
	Weeks
	Months
)

func (p RentalPeriod) ToDays() int {
	switch p {
	case Weeks:
		return 7
	case Months:
		return 30
	default:
		return 1
	}
}

func (r Rental) Cost() float64 {
	return r.feePerDay * float64(r.ToDays()*r.periodLength)
}

func main() {
	shoes := Item{"Sport shoes", 30000, 2}
	eventShoes := DiscountItem{
		Item{"women's Walking Shoes", 50000, 3}, 10.00}

	displayCost(shoes)
	displayCost(eventShoes)

	shirt := Item{"Men's slim fit shirt", 25000, 3}
	video := Rental{"Intersteller", 1000, 3, Days}

	displayCost(shirt)
	displayCost(video)
}
