function [beam]=Toy_example

car_speed=(rand(1,1000)*30+30)/3.6;
%km/h=m/s*1000/3600
car_location(1)=-1000;
BS_angle(1)=atan(-10)*180/pi;
beam(1)=round(BS_angle(1)/10)+9;
for k=2:1000
    car_location(k)=min(car_location(k-1)+car_speed(k-1),1000);
    BS_angle(k)=atan(car_location(k)/100)*180/pi;
    beam(k)=round(BS_angle(k)/10)+9;
end    
end
