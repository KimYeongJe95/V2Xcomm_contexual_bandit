%%Single_context_bandit v.1.0
%%2020.07.15 김영제

%%decaying epsilon greedy policy를 이용하여 beam을 가장 잘 추정하는 bandit을 만드는 것이 목적임.

%%context는 1ms 이전에 어떤 beam 위에 있었는지로 함.
%%beam과 동일한 arm을 selection하면 reward=1, 아닐경우 reward=0으로 하는 가장 쉬운 bandit을 설계
%%각 시간에 따라서 proper한 selection이 달라진다는 것을 구현해야함.

%%가장 간단하게 (context)*(action)인 행렬을 만들어서 기댓값을 update해주는 방식을 사용함.
function [r_expectation,r_reward,r_count]=one_context_bandit
   global mat_count;
   mat_count=zeros(17,17);
   global mat_expectation;
   mat_expectation=zeros(17,17);
   global mat_reward;
   mat_reward=zeros(17,17);
   %%각 context에 따라서 action의 기댓값이 변하게됨. 이것을 표현하는 방식으로 nXn matrix를 만드는 것임.
   %%이때, context가 많아지면 행렬의 size가 너무 커지는 문제가 생기게 됨. 이를 어떻게 해결할지를 고민해봐야함.
   
   scenario_rep=5000;
   total_time=150;
   total_rep=0;
   repetition=0;
   total_reward=0;
   counting=[];
   
   for nth_scenario=1:scenario_rep
       global beam;
       beam=Toy_example;
       for time=2:total_time
           total_rep=total_rep+1;
           epsilon=max(0.01,(1-total_rep/100000));
           random=rand();
           if random>epsilon
               total_reward=total_reward+exploitation(time,beam(time-1));
           else
               total_reward=total_reward+exploration(time,beam(time-1));
           end
       end
       if rem(nth_scenario,10)==0
           stop=1;
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

function trial_reward=exploitation(input1,input2)
%%input1은 현재 time이다.
%%input2은 이전의 time에서 어떤 beam을 이용하는지이다. 이 bandit에서는 context로 사용하였다.
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    temp_reward=mat_reward(:,input2);
    temp_count=mat_count(:,input2);
    temp_expectation=mat_expectation(:,input2);
    
    [m,i]=max(temp_expectation);
    if beam(input1)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,input2)=temp_reward;
    mat_count(:,input2)=temp_count;
    mat_expectation(:,input2)=temp_expectation;
end

function trial_reward=exploration(input1,input2)
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    temp_reward=mat_reward(:,input2);
    temp_count=mat_count(:,input2);
    temp_expectation=mat_expectation(:,input2);
    
    i=randi(17);
    
    if beam(input1)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,input2)=temp_reward;
    mat_count(:,input2)=temp_count;
    mat_expectation(:,input2)=temp_expectation;
end

%%Note: 간단한 bandit을 context의 수만큼 만드는 방식으로 만들어진 contextual bandit이다.
%%이렇게 만들경우 비교적 쉽게 만들 수 있지만 각각의 bandit의 iteration이 떨어지게 된다는 단점이 존재한다.
%%이것과는 달리 신경망을 이용하는게 더 좋을듯함.