#fixing to use Binet's Formula, as it's faster than recursion
#combining all the code in 1 function, instead of 4
#removing extra lines
#using local variables instead of global constants

def series(sequence, n)
  alpha = (1 + Math.sqrt(5)) / 2
  beta = 1 - alpha
  return ((alpha**n - beta**n) / Math.sqrt(5)).to_i if sequence == "fibonacci"
  return (alpha**(n - 1) + beta**(n - 1)).to_i if sequence == "lucas"
  return series("fibonacci", n) + series("lucas", n) if sequence == "summed"
end