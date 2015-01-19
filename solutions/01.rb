def series(sequence, number)
  case sequence
    when "fibonacci" then fibonacci(number)
    when "lucas"     then lucas(number)
    when "summed"    then summed(number)
  end
end

def fibonacci(number)
  if number == 1 or number == 2
    1
  else
    fibonacci(number - 1) + fibonacci(number - 2)
  end
end

def lucas(number)
  case number
    when 1 then 2
    when 2 then 1
    else lucas(number - 1) + lucas(number - 2)
  end
end

def summed(number)
  fibonacci(number) + lucas(number)
end