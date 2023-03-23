using WGLMakie
using Observables

using Unfold
using UnfoldSim
using Random

using Markdown
using JSServe
import JSServe.TailwindDashboard as D
#---
begin
    sfreq = 250.
    #gen_data(noise) = gen_data(MersenneTwister(1),1.,sfreq,noise)
    gen_data(rng::Int,args...) = gen_data(MersenneTwister(rng),args...)
	function gen_data(rng,noiselevel,noise)
        
        tmp = Symbol(noise)
        f = getfield(Main,tmp)
        dat,evts = UnfoldSim.predef_eeg(rng;sfreq=sfreq,
		    n1 = (n170(;sfreq=sfreq), @formula(0~1+condition),[5,0],Dict()),
		    p3 = (p300(;sfreq=sfreq), @formula(0~1+continuous),[5,0],Dict()),
		    n_repeats=20,noise=f(;noiselevel=noiselevel))
		return (;dat,evts)
	end

    
    function calc_model(τ,(;evts,dat))
        twindow = (-0.1,Float64(τ))
        m = fit(UnfoldModel,Dict(Any=>(@formula(0~1),firbasis(twindow,sfreq,string(twindow)))),evts,dat);
        c = coeftable(m)
        time = c.time
        estimate = c.estimate
        return (;time,estimate)
    end
end
#---
volume_app = App(title="Volume") do session::Session
    noises = ["PinkNoise", "RedNoise", "WhiteNoise"]
    noise = Observable(first(noises))
    noise_drop = D.Dropdown("Noise", noises)
    noise = noise_drop.value
    
    end_time = D.Slider("end time", LinRange(0.0f0, 2.0f0, 50))
    noiselevel = D.Slider("noiselevel", LinRange(0.0f0, 10.0f0, 20))


    seed = Observable(1)
    fig = Figure()
    ax = fig[1,1] = Axis(fig)

 
    
    #dat,evts = gen_data("PinkNoise")    

    obs_data  = map(gen_data,seed,noiselevel.value,noise_drop.value)
    result = map(calc_model,end_time.value,obs_data)
    
    
    points1 = map(result) do args
        (;time,estimate) = args
        return Point2f.(time,estimate)
        
    end
    hold_toggle = Checkbox(false)#"hold on / off")
    
    pointsAll = Observable([[Point2f(1,2),Point2f(1,2)],[Point2f(1,2),Point2f(1,2)]])
    map(hold_toggle,points1) do tog,p
        if tog
       #     @show [pointsAll.val...,[p]]
       #     @show typeof([pointsAll.val...,[p]])
          #  pointsAll[] =  [[p]]
          @show typeof(pointsAll.val)
          @show size.(pointsAll.val)
          pointsAll[] =  [pointsAll.val[1],points1.val]
        else
            pointsAll[] =  [points1.val,[]]
        end
    end
    hlines!(ax,[0],color=:lightgray)
    vlines!(ax,[0],color=:lightgray)
    (;time,estimate) = calc_model(0.5,gen_data(1,0,"WhiteNoise"))
    lines!(ax,time,estimate,color=:gray)
    series!(ax, pointsAll)
    
    ylims!(ax,[-5,10])
    xlims!(ax,[-0.3,2])

    seed_button = Button("New random sample")

    



    map(seed_button) do click
        seed[] = abs.(rand(Int,1)[1])
    end

    return D.FlexRow(
        D.Card(D.FlexCol(
            end_time,
            noise_drop,
            noiselevel,
            seed_button,
            D.FlexRow(md"Hold plot? ",hold_toggle),

        )),
        D.Card(fig)
    )
end;
#route!(server,"/"=>volume_app)
#---
if 1 == 0
    server = JSServe.Server(volume_app, "127.0.0.1", 8081)
#---
#JSServe.route!(JSServe.get_server(), "/" => volume_app)
#---
display(volume_app)
#---
end