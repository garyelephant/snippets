Now we will see how to find a fitting polynomial for the data using the function polyfit provided by numpy:

```
from numpy import *
import pylab

# data to fit
x = random.rand(6)
y = random.rand(6)

# fit the data with a 4th degree polynomial
z4 = polyfit(x, y, 4) 
p4 = poly1d(z4) # construct the polynomial 

z5 = polyfit(x, y, 5)
p5 = poly1d(z5)

xx = linspace(0, 1, 100)
pylab.plot(x, y, 'o', xx, p4(xx),'-g', xx, p5(xx),'-b')
pylab.legend(['data to fit', '4th degree poly', '5th degree poly'])
pylab.axis([0,1,0,1])
pylab.show()
```

Let's see the two polynomials:

![](http://4.bp.blogspot.com/-vF7Imp370Bw/Thydr_AOpfI/AAAAAAAAAEU/cIUwd69rXNU/s320/poly.png)

---

article from : http://glowingpython.blogspot.com/2011/07/polynomial-curve-fitting.html
