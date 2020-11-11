using RollingFunctions, Distributions, DataFrames
function EARS_C1(cases; alpha_val = 0.05, epsilon = 0, previous_days = 7, initial_date = 1)
    #Author: rodrigo.zepeda@imss.gob.mx
    #EXAMPLE:
    #cases = [1,2,1,0,0,1,2,3,1,1,0,0,0,1,20,40,1,1,1,0,0,0,1,1]
    #detected = EARS_C1(cases, initial_date = 1)
    #detected = EARS_C1([0,0,100], previous_days = 2) #Alerta en 100
    #detected = EARS_C1([0,0,100], previous_days = 3) #No sirve
    if (previous_days < length(cases))
        Ybar        = rollmean(cases, previous_days)
        sd          = map((x) -> maximum([x,epsilon]), rollstd(cases, previous_days))
        Y           = cases[(previous_days + 1):length(cases)]
        upper_bound = Ybar + quantile.(Normal(0, 1), 1 - alpha_val) * sd
        upper_bound = upper_bound[1:(length(upper_bound) - 1)]
        alert       = Y .> upper_bound
        idate       = (initial_date + previous_days):(initial_date + length(cases) - 1)
    else
        error("Vector cases too small. Need cases > previous_days for rollingmean")
    end
    return DataFrame(Alert = alert, U = upper_bound, Date = idate)
end
