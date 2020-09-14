%%Single_context_bandit v.1.0
%%2020.07.15 �迵��

%%decaying epsilon greedy policy�� �̿��Ͽ� beam�� ���� �� �����ϴ� bandit�� ����� ���� ������.

%%context�� 1ms ������ � beam ���� �־������� ��.
%%beam�� ������ arm�� selection�ϸ� reward=1, �ƴҰ�� reward=0���� �ϴ� ���� ���� bandit�� ����
%%�� �ð��� ���� proper�� selection�� �޶����ٴ� ���� �����ؾ���.

%%���� �����ϰ� (context)*(action)�� ����� ���� ����� update���ִ� ����� �����.
function [r_expectation,r_reward,r_count]=one_context_bandit
   global mat_count;
   mat_count=zeros(17,17);
   global mat_expectation;
   mat_expectation=zeros(17,17);
   global mat_reward;
   mat_reward=zeros(17,17);
   %%�� context�� ���� action�� ����� ���ϰԵ�. �̰��� ǥ���ϴ� ������� nXn matrix�� ����� ����.
   %%�̶�, context�� �������� ����� size�� �ʹ� Ŀ���� ������ ����� ��. �̸� ��� �ذ������� ����غ�����.
   
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
%%input1�� ���� time�̴�.
%%input2�� ������ time���� � beam�� �̿��ϴ����̴�. �� bandit������ context�� ����Ͽ���.
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

%%Note: ������ bandit�� context�� ����ŭ ����� ������� ������� contextual bandit�̴�.
%%�̷��� ������ ���� ���� ���� �� ������ ������ bandit�� iteration�� �������� �ȴٴ� ������ �����Ѵ�.
%%�̰Ͱ��� �޸� �Ű���� �̿��ϴ°� �� ��������.