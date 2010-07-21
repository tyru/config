#!/usr/bin/env python
# coding: utf-8



def do_fizzbuzz(i):
	if i % 15 == 0:
		return "FizzBuzz"
	elif i % 5 == 0:
		return "Buzz"
	elif i % 3 == 0:
		return "Fizz"
	else:
		return str(i)

def fizzbuzz(*args):
	for i in apply(range, args):
		yield do_fizzbuzz(i)

def main():
	for s in fizzbuzz(1, 100):
		print s

if __name__ == '__main__':
	main()
