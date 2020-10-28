using RollingFunctions, Distributions, DataFrames
function EARS_C1(cases; alpha_val = 0.05, epsilon = 0, previous_days = 7, initial_date = 1)
    #EXAMPLE:
    #cases = [1,2,1,0,0,1,2,3,1,1,0,0,0,1,2,1,1,1,1,0,0,0,1,1]
    #detected = EARS_C1(cases, initial_date = 1)
    if (previous_days < length(cases))
        Ybar        = rollmean(cases, previous_days)
        sd          = map((x) -> maximum([x,epsilon]), rollstd(cases, previous_days))
        Y           = cases[previous_days:length(cases)]
        upper_bound = Ybar + quantile.(Normal(0, 1), 1 - alpha_val) * sd
        alert       = Y .> upper_bound
        idate       = (initial_date + previous_days - 1):(initial_date + length(cases) - 1)
    else
        error("Vector cases too small. Need cases > previous_days for rollingmean")
    end
    return DataFrame(Alert = alert, U = upper_bound, Date = idate)
end
