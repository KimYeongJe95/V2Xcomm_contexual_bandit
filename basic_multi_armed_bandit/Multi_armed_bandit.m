function Multi_armed_bandit(strategy,rep)
%%�Լ��� 0�� �Է½� exploration�� ��.
%%�Լ��� 1�� �Է½� decaying_epsilon greedy ����� �����.
%%�Լ��� 2�� �Է½� epsilon greedy ����� �����.


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

%%main�Լ��� strategy�� ���� �ൿ�� �����ϰ� repetition�� ���� ���� ���ߴ°� main purpose
%%arm�� ���� ���, arm_expectation�� nȸ �ݺ����� ���
function arm=arm_generation
arm=[];
for i=0:1:9
    arm_plus=rand(1);
    arm=horzcat(arm,arm_plus);
end    
%%10���� arm�� ���� �ٸ� ����� �������� ��.
%%����� ���� ���� ������ ���� Ȯ��(1������ 10������)

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

