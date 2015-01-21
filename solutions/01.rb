#fixing to use Binet's Formula, as it's faster than recursion
#combining all the code in 1 function, instead of 4
#removing extra lines

ALPHA = (1 + Math.sqrt(5)) / 2
BETA = 1 - ALPHA

def series(sequence, n)
  case sequence
    when "fibonacci" then ((ALPHA**n - BETA**n) / Math.sqrt(5)).to_i
    when "lucas"     then (ALPHA**(n - 1) + BETA**(n - 1)).to_i
    when "summed"    then series("fibonacci", n) + series("lucas", n)
  end
end