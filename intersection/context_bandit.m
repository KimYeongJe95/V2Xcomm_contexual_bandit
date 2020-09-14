%%contextual_bandit_for_crossroad_env. v.1.0
%%2020.08.29 Kim Yeong_Je

%%decaying epsilon greedy policy�� �̿��Ͽ� beam�� ���� �� �����ϴ� bandit�� ����� ���� ����

%%context�� ������ ������ġ,�ӵ�,�������� ��.
%%���� 3���� �� �� ��ġ�� �ӵ��� �������� ���̹Ƿ� �Է��� ���� �� ������ ���� bandit�� ��ǥ���� �Է�����.

%%���� bandit�� ���������� (context)*(action)�� ����� ���� ����� update���ִ� ����� �����.
function [r_expectation,r_reward,r_count]=context_bandit
    clf;
    scenario_rep=250000;
    total_time=150;
    
    total_rep=0;
    repetition=0;
    counting=[];
    total_reward=0;
    r=0.01;%learning rate
    global mat_count;
    mat_count=zeros(24,52,52);
    global mat_expectation;
    mat_expectation=zeros(24,52,52);
    global mat_reward;
    mat_reward=zeros(24,52,52);
    
    for nth_scenario=1:scenario_rep
            global beam;    global x_location;    global y_location;
            [x_location,y_location,beam]=Crossroad_env;
            for time=2:total_time
                total_rep=total_rep+1;
                epsilon=max(r,(1-nth_scenario/25000));
                random=rand();
                pre_xloca=round(x_location(time-1)./2)+26;
                pre_yloca=round(y_location(time-1)./2)+26;
                if random>epsilon
                    total_reward=total_reward+exploitation(time,pre_xloca,pre_yloca);
                else
                    total_reward=total_reward+exploration(time,pre_xloca,pre_yloca);
                end
            end
            if rem(time,10)==0
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

function trial_reward=exploitation(input1,input2,input3)
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    temp_reward=mat_reward(:,input2,input3);
    temp_count=mat_count(:,input2,input3);
    temp_expectation=mat_expectation(:,input2,input3);
    
    [m,i]=max(temp_expectation);
    if beam(input1)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,input2,input3)=temp_reward;
    mat_count(:,input2,input3)=temp_count;
    mat_expectation(:,input2,input3)=temp_expectation;
    
end

function trial_reward=exploration(input1,input2,input3)
    global mat_reward
    global mat_count
    global mat_expectation
    global beam
    
    temp_reward=mat_reward(:,input2,input3);
    temp_count=mat_count(:,input2,input3);
    temp_expectation=mat_expectation(:,input2,input3);
    
    i=randi(24);
    
    if beam(input1)==i
        trial_reward=1;
    else
        trial_reward=0;
    end
    temp_reward(i)=temp_reward(i)+trial_reward;
    temp_count(i)=temp_count(i)+1;
    temp_expectation(i)=temp_reward(i)./temp_count(i);
    
    mat_reward(:,input2,input3)=temp_reward;
    mat_count(:,input2,input3)=temp_count;
    mat_expectation(:,input2,input3)=temp_expectation;
end