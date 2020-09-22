%%contextual bandit for crossroad env v.2.0
%%2020.09.22 Kim Yeong_Je

%%Main purpose is to make the bandit which finds optimal beams during scenario using decaying
%%epsilon greedy policy.

%%Former angle of Vehicle&BS will be used as a context

function [r_expectation,r_reward,r_count]=context_bandit_v2_0
    clf;
    scenario_rep=30000;
    total_time=150;
    
    total_rep=0;
    counting=[];
    total_reward=0;
    r=0.01;
    global mat_count;
    mat_count=zeros(24,25);
    global mat_expectation;
    mat_expectation=zeros(24,25);
    global mat_reward;
    mat_reward=zeros(24,25);
    
    for nth_scenario=1:scenario_rep
        global beam;
        [~,~,beam]=Crossroad_env;
        for time=2:total_time
            total_rep=total_rep+1;
            epsilon=max(r,(1-nth_scenario/5000));
            random=rand();
            if random>epsilon
                total_reward=total_reward+exploitation(time);
            else
                total_reward=total_reward+exploration(time);
            end
        end
        counting=horzcat(counting,total_reward./total_rep);
    end
    
    r_expectation=mat_expectation;
    r_reward=mat_reward;
    r_count=mat_count;
    plot(counting);
    xlabel('number of iteration')
    ylabel('average reward')
    title('contextual bandit')

end

function trial_reward=exploitation(time)
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    tmp_beam=beam(time-1)+1;
    temp_reward=mat_reward(:,tmp_beam);
    temp_count=mat_count(:,tmp_beam);
    temp_expectation=mat_expectation(:,tmp_beam);
    
    [m,i]=max(temp_expectation);
    if beam(time)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,tmp_beam)=temp_reward;
    mat_count(:,tmp_beam)=temp_count;
    mat_expectation(:,tmp_beam)=temp_expectation;
end

function trial_reward=exploration(time)
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    tmp_beam=beam(time-1)+1;
    temp_reward=mat_reward(:,tmp_beam);
    temp_count=mat_count(:,tmp_beam);
    temp_expectation=mat_expectation(:,tmp_beam);
    
    i=randi(24);
    
    if beam(time)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,tmp_beam)=temp_reward;
    mat_count(:,tmp_beam)=temp_count;
    mat_expectation(:,tmp_beam)=temp_expectation;
end
