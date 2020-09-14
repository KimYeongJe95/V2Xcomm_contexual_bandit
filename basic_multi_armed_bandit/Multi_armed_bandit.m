function Multi_armed_bandit(strategy,rep)
%%함수에 0을 입력시 exploration만 함.
%%함수에 1을 입력시 decaying_epsilon greedy 방법을 사용함.
%%함수에 2를 입력시 epsilon greedy 방법을 사용함.


global repetition
repetition=1;
global arm
arm=arm_generation();
global arm_expectation
arm_expectation=zeros(1,10);
global arm_count
arm_count=zeros(1,10);
global arm_reward
arm_reward=zeros(1,10);
global total_reward
total_reward=0;
total_repetition=rep;
counting=[];
if strategy==1
    for i=0:1:total_repetition
    epsilon=max(0.01,(1-repetition/10000));
       random=rand();
       if random>epsilon
           total_reward=total_reward+exploitation();
       else
           total_reward=total_reward+exploration();
       end
       counting=horzcat(counting,total_reward./repetition);
       repetition=repetition+1;
    end
elseif strategy==2
    for i=0:1:total_repetition
    epsilon=0.1;
       random=rand();
       if random>epsilon
           total_reward=total_reward+exploitation();
       else
           total_reward=total_reward+exploration();
       end
       counting=horzcat(counting,total_reward./repetition);
       repetition=repetition+1;
    end
elseif strategy==0
    for i=0:1:total_repetition
        total_reward=total_reward+exploration();
        counting=horzcat(counting,total_reward./repetition);
        repetition=repetition+1;
    end
end
reward_rate=total_reward./(max(arm).*total_repetition);
total_reward
arm
arm_expectation
reward_rate
plot(counting)
xlabel('number of iteration')
ylabel('average reward')
if strategy==0
    title('random exploration')
elseif strategy==1
    title('Decaying-epsilon greedy policy')
elseif strategy==2
    title('Epsilon greedy policy')
end

%%main함수는 strategy에 따라 행동을 결정하고 repetition에 따라 값을 맞추는게 main purpose
%%arm은 실제 기댓값, arm_expectation은 n회 반복후의 기댓값
function arm=arm_generation
arm=[];
for i=0:1:9
    arm_plus=rand(1);
    arm=horzcat(arm,arm_plus);
end    
%%10개의 arm이 각자 다른 기댓값을 가지도록 함.
%%행렬이 가진 값이 보상을 받을 확률(1번부터 10번까지)

function trial_reward=exploitation()
global arm_reward
global arm_expectation
global arm_count
global arm
global repetition
[m,i]=max(arm_expectation);
if arm(i)>rand()
    trial_reward=1;
else
    trial_reward=0;
end
arm_reward(i)=arm_reward(i)+trial_reward;
arm_count(i)=arm_count(i)+1;
arm_expectation(i)=arm_reward(i)./arm_count(i);


function trial_reward=exploration()
global arm_reward
global arm_count
global arm_expectation
global arm
global repetition
i=randi(10);
if arm(i)>rand()
    trial_reward=1;
else
    trial_reward=0;
end
arm_reward(i)=arm_reward(i)+trial_reward;
arm_count(i)=arm_count(i)+1;
arm_expectation(i)=arm_reward(i)./arm_count(i);

