# dual_number

![](https://github.com/tomstuart/dual_number/workflows/Ruby/badge.svg)

This library provides a Ruby implementation of [dual numbers](https://en.wikipedia.org/wiki/Automatic_differentiation), which are useful for forward mode [automatic differentiation](https://en.wikipedia.org/wiki/Automatic_differentiation).

It is intended to accompany the article [“Automatic differentiation in Ruby”](http://codon.com/automatic-differentiation-in-ruby).

That article explains the details, but here’s a brief demonstration:

```irb
$ irb -Ilib
>> require 'dual_number'
=> true

>> x = DualNumber(1, 2)
=> (1+2ε)

>> y = DualNumber(3, 4)
=> (3+4ε)

>> x + y
=> (4+6ε)

>> x * y
=> (3+10ε)

>> (x + 3) * 4
=> (16+8ε)

>> 3 + (4 * x)
=> (7+8ε)
```

One application of dual numbers is to use the second (“dual”) component to represent the derivative of the first (“real”) component. This lets us find the derivative of a function at a particular value by just passing in a dual number instead of a normal number:

```irb
>> def distance(time:)
     time * Math.sin(time * time) + 1
   end
=> :distance

>> value_and_derivative = distance(time: DualNumber(3, 1))
=> (2.2363554557252696-15.988226228682427ε)

>> value_and_derivative.real
=> 2.2363554557252696

>> value_and_derivative.dual
=> -15.988226228682427
```

If you have any questions, please get in touch via [Twitter](http://twitter.com/tomstuart) or [email](mailto:tom@codon.com). If you find any bugs or other problems with the code, please [open an issue](https://github.com/tomstuart/dual_number/issues/new).
