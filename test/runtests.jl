using DeepRL
using POMDPModels
using Base.Test

include("zmq.jl")

function sim(env, nsteps=100, rng=MersenneTwister(0))
    o = reset(env)
    step = 1
    done = false
    r_tot = 0.0
    na = n_actions(env)
    dims = obs_dimensions(env)
    while !done && step <= nsteps
        action = sample_action(env)
        obs, rew, done, info = step!(env, action)
        #println(obs, " ", rew, " ", done, " ", info)
        r_tot += rew
        step += 1
    end
    return r_tot
end

envs = [MDPEnvironment(GridWorld()),
        MDPEnvironment(InvertedPendulum()),
        MDPEnvironment(MountainCar()),
        POMDPEnvironment(TMaze()),
        POMDPEnvironment(BabyPOMDP()),
        POMDPEnvironment(TigerPOMDP()),
        KMarkovEnvironment(TMaze(), k=4),
        KMarkovEnvironment(BabyPOMDP(), k=4),
        KMarkovEnvironment(TigerPOMDP(), k=4)]

for env in envs
    r = sim(env)
    process(env)
end
