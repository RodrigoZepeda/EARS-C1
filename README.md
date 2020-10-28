# EARS-C1
Implementation of EARS-C1 algorithm in Julia. To run just include the function in your code:

```
#Setup in Julia
include("EARS_C1.jl")
```

and run the function over any list of cases observed at the same time step:

```
#Running in Julia
cases = [1,2,1,0,0,1,2,3,1,1,0,0,0,1,2,1,1,1,1,0,0,0,1,1]
detected = EARS_C1(cases, initial_date = 1)
```

You can also run the algorithm from `R` using `JuliaCall`:
```
#Setup in R
library(JuliaCall)
julia <- julia_setup()
julia_command('include("EARS_C1.jl")')
```

and then call the function:
```
cases    <- rpois(100,20)                #Simulate cases
julcases <- julia_eval("EARS_C1")(cases) #Evaluate function
```

The algorithm is faster than current implementation in the `surveillance` package:

```
library(surveillance)
library(microbenchmark)
#Comparación de tiempos
mb <- microbenchmark(
  cases    <- rpois(100, 20),
  julcases <- julia_eval("EARS_C1")(cases),
  surv     <- earsC(as(ts(cases, start = 1),"sts"), control = list(method = "C1", alpha = 0.05, baseline = 7, minSigma = 0)),
  times = 1000
)
```

With results:
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> expr </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> lq </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> uq </th>
   <th style="text-align:right;"> max </th>
   <th style="text-align:right;"> neval </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> cases &lt;- rpois(100, 20) </td>
   <td style="text-align:right;"> 12.356 </td>
   <td style="text-align:right;"> 18.329 </td>
   <td style="text-align:right;"> 24.32397 </td>
   <td style="text-align:right;"> 23.7460 </td>
   <td style="text-align:right;"> 26.8080 </td>
   <td style="text-align:right;"> 99.146 </td>
   <td style="text-align:right;"> 1000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> julcases &lt;- julia_eval(&quot;EARS_C1&quot;)(cases) </td>
   <td style="text-align:right;"> 425.427 </td>
   <td style="text-align:right;"> 573.103 </td>
   <td style="text-align:right;"> 766.03114 </td>
   <td style="text-align:right;"> 654.5255 </td>
   <td style="text-align:right;"> 749.8775 </td>
   <td style="text-align:right;"> 53798.048 </td>
   <td style="text-align:right;"> 1000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> surv &lt;- earsC(as(ts(cases, start = 1), &quot;sts&quot;), control = list(method = &quot;C1&quot;,      alpha = 0.05, baseline = 7, minSigma = 0)) </td>
   <td style="text-align:right;"> 4400.425 </td>
   <td style="text-align:right;"> 5103.316 </td>
   <td style="text-align:right;"> 6045.99175 </td>
   <td style="text-align:right;"> 5582.3825 </td>
   <td style="text-align:right;"> 6040.5920 </td>
   <td style="text-align:right;"> 45565.106 </td>
   <td style="text-align:right;"> 1000 </td>
  </tr>
</tbody>
</table>

