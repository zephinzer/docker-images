package main

import (
	"fmt"
	"testing"
)

func TestOne(t *testing.T) {
	fmt.Println("Test 1 passes")
}

func TestTwo(t *testing.T) {
	fmt.Println("Test 2 passes too")
}

func TestThree(t *testing.T) {
	panic("Test 3 fails")
}
