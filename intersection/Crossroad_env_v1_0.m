%%2020.08.29 Kim Yeong_Je
%%Crossroad movement of car
%%we can get location,optimal_beam,current_speed,direction of car and
%%location of crosspoint automatically.
%%���� ������(������ ��ġ,������ ��,���� �ӵ�) 4���� �̿��ؼ� 4���� input�� ������ contextual
%%bandit�� ����� ���� �̹� toy_example�� ��ǥ�̴�.
function [x_location,y_location,beam,speed,direction,crosspoint]=Crossroad_env_v1_0
%%plot�� contexual bandit�� �����Կ� �־� ������� ����.
    clear; clf;
    global width; 
    
    upper_bound=50;
    lower_bound=-50;    
    width=2.5;
    
    global vertical_road;
    global horizontal_road;
    
    vertical_road_x=[lower_bound,upper_bound];
    vertical_road_y=[30*rand(1)-15,30*rand(1)-15];
    vertical_road=polyfit(vertical_road_x,vertical_road_y,1);
    
    horizontal_road_x=[30*rand(1)-15,30*rand(1)-15];
    horizontal_road_y=[lower_bound,upper_bound];
    horizontal_road=polyfit(horizontal_road_x,horizontal_road_y,1);
    
    crosspoint=[(vertical_road(2)-horizontal_road(2))./(horizontal_road(1)-vertical_road(1)),
vertical_road(1).*(vertical_road(2)-horizontal_road(2))./(horizontal_road(1)-vertical_road(1))+vertical_road(2)];
           
    for k=1:100
        xv_1(k)=vertical_road_x(1)+(k-1);
        yv_1(k)=vertical_road(1)*xv_1(k)+vertical_road(2)-width;
        
        xv_2(k)=vertical_road_x(1)+(k-1);
        yv_2(k)=vertical_road(1)*xv_1(k)+vertical_road(2)+width;
        
        yh_1(k)=horizontal_road_y(1)+(k-1);
        xh_1(k)=((yh_1(k)-horizontal_road(2))/horizontal_road(1))-width;
        
        yh_2(k)=horizontal_road_y(1)+(k-1);
        xh_2(k)=((yh_2(k)-horizontal_road(2))/horizontal_road(1))+width;
        
        plot(xv_1,yv_1,'--r',xv_2,yv_2,'--r',xh_1,yh_1,'--r',xh_2,yh_2,'--r');
        axis([-50 50 -50 50]);
        hold on;
        
    end

    car_location(1)=-50;    
    car_location(2)=vertical_road(1)*(-50)+vertical_road(2);
    car_direction=1;
    direction_change=0;
    %������ ��ġ�̵�
    %%���� ��ġ, ���� �ӵ�, ���� ���� ��� �ð����� ��Ŀ� �����ؾ� ��.
    direction=zeros(1,150);
    speed=zeros(1,150);
    
    direction(1)=1;
    for i=2:150
        if car_location(2*i-3)>=-50 && car_location(2*i-3)<=50 && car_location(2*i-2)>=-50 && car_location(2*i-2)<=50
            [x_speed,y_speed]=car_loca(car_direction,car_location(2*i-3),car_location(2*i-2));
            car_location(2*i-1)=car_location(2*i-3)+x_speed;
            car_location(2*i)=car_location(2*i-2)+y_speed;
        else
            x_speed=0;
            y_speed=0;
            car_location(2*i-1)=car_location(2*i-3)+x_speed;
            car_location(2*i)=car_location(2*i-2)+y_speed;
        end
        if direction_change==0
            if car_location(2*i-1)>crosspoint(1)-width && car_location(2*i-1)<crosspoint(1)+width
                if car_location(2*i)>crosspoint(2)-width && car_location(2*i)<crosspoint(2)+width
                    direction_change=1;
                    car_direction=round(4*rand(1)+0.5);
                end
            end
        end
        direction(i)=car_direction;
        speed(i-1)=sqrt(x_speed.^2+y_speed.^2);
    end
    speed(150)=0;
    
    %%����ġ Ž�� �� ����� ����
    x_location=zeros(1,150);
    y_location=zeros(1,150);
    for j=1:150
        x_location(j)=car_location(2*j-1);
        y_location(j)=car_location(2*j);
    end
    
    angle=zeros(1,150);
    for k=1:150
        if x_location(k)>0 && y_location(k)>0
            angle(k)=atan(y_location(k)/x_location(k))*180/pi;
        elseif x_location(k)<0 && y_location(k)<0
            angle(k)=(atan(y_location(k)/x_location(k))*180/pi)+180;
        elseif x_location(k)>0 && y_location(k)<0
            angle(k)=(atan(y_location(k)/x_location(k))*180/pi)+360;
        elseif x_location(k)<0 && y_location(k)>0
            angle(k)=(atan(y_location(k)/x_location(k))*180/pi)+180;
        end
        beam(k)=round(angle(k)/15);
    end
    
    grid on;    
    for a=1:150
        x_t=x_location(1:a);
        y_t=y_location(1:a);
        plot(x_t,y_t);     
        drawnow;
    end

end

%%������ ��ġ�� ������ �̿��ؼ� ���� ������ ������.
%%���θ� gloval value�� ǥ���ؼ� ���⼭�� �״�� �̿��� �� ����.
%%direction�������δ� ū ���� ���, ������ �������δ� +-������ ���� ���� ������ random���� �̵��ϰ� ����.
function [x_speed,y_speed]=car_loca(direction,x_loca,y_loca)
    global vertical_road;
    global horizontal_road;
    global width;

    if direction==1
        x_speed=0.5*rand(1)+0.5;
        if y_loca>vertical_road(1)*x_loca+vertical_road(2)-width && y_loca<vertical_road(1)*x_loca+vertical_road(2)+width
            y_speed=0.2*rand(1)-0.1+(vertical_road(1)*x_speed);
        elseif y_loca>vertical_road(1)*x_loca+vertical_road(2)+width
            y_speed=-0.2*rand(1)-abs(vertical_road(1)*x_speed);
        elseif y_loca<vertical_road(1)*x_loca+vertical_road(2)-width
            y_speed=0.2*rand(1)+abs(vertical_road(1)*x_speed);
        end
    elseif direction==2
        y_speed=0.5*rand(1)+0.5;
        if x_loca>(y_loca-horizontal_road(2))/horizontal_road(1)-width && x_loca<(y_loca-horizontal_road(2))/horizontal_road(1)+width
            x_speed=0.2*rand(1)-0.1+(y_speed/horizontal_road(1));
        elseif x_loca>(y_loca-horizontal_road(2))/horizontal_road(1)+width
            x_speed=-0.2*rand(1)-abs(y_speed/horizontal_road(1));
        elseif x_loca<(y_loca-horizontal_road(2))/horizontal_road(1)-width
            x_speed=0.2*rand(1)+abs(y_speed/horizontal_road(1));
        end
    elseif direction==3
        x_speed=-0.5*rand(1)-0.5;
        if y_loca>vertical_road(1)*x_loca+vertical_road(2)-width && y_loca<vertical_road(1)*x_loca+vertical_road(2)+width
            y_speed=0.2*rand(1)-0.1+(vertical_road(1)*x_speed);
        elseif y_loca>vertical_road(1)*x_loca+vertical_road(2)+width
            y_speed=-0.2*rand(1)-abs(vertical_road(1)*x_speed);
        elseif y_loca<vertical_road(1)*x_loca+vertical_road(2)-width
            y_speed=0.2*rand(1)+abs(vertical_road(1)*x_speed);
        end
    elseif direction==4
        y_speed=-0.5*rand(1)-0.5;
        if x_loca>(y_loca-horizontal_road(2))/horizontal_road(1)-width && x_loca<(y_loca-horizontal_road(2))/horizontal_road(1)+width
            x_speed=0.2*rand(1)-0.1+(y_speed/horizontal_road(1));
        elseif x_loca>(y_loca-horizontal_road(2))/horizontal_road(1)+width
            x_speed=-0.2*rand(1)-abs(y_speed/horizontal_road(1));
        elseif x_loca<(y_loca-horizontal_road(2))/horizontal_road(1)-width
            x_speed=0.2*rand(1)+abs(y_speed/horizontal_road(1));
        end
    end
end