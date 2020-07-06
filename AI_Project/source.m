% script for geneating simulated data
close all
clear
clc

%Call simulation function, where detectionOutput is the return value

detectionOutput=runSimulation;
output = detectionOutput;
%output(:,1) = output(:,1)+100;
%output(:,2) = output(:,2)+100;
fid = fopen('C:\Users\Haze5\OneDrive\Documents\MATLAB\School\AI_Project\AI_Project\AI_Project\input.txt','w');
fprintf(fid,'%d\t%d\n',round(50*rand(1)),round(50*rand(1)));
fprintf(fid,'%d\t%d\n',round(50*rand(1)),round(50*rand(1)));
sze = size(detectionOutput);
for ii = 1:sze(1)
    fprintf(fid,'%d\t%d\t%f\n',output(ii,1), output(ii,2), output(ii,3));
end
fclose(fid);



for i=1:sze(1)
   if detectionOutput(i,3)<300
       scatter(detectionOutput(i,1),detectionOutput(i,2),1,'k');
   end
   if detectionOutput(i,3)>300 && detectionOutput(i,3)<600
       scatter(detectionOutput(i,1),detectionOutput(i,2),1,'m');
   end
   if detectionOutput(i,3)>600 && detectionOutput(i,3)<900
       scatter(detectionOutput(i,1),detectionOutput(i,2),1,'g');
   end
   if detectionOutput(i,3)>900 && detectionOutput(i,3)<1200
       scatter(detectionOutput(i,1),detectionOutput(i,2),1,'b');
   end
   if detectionOutput(i,3)>1200
       scatter(detectionOutput(i,1),detectionOutput(i,2),1,'r');
   end
end
%detectionOutput(:,3)=1./detectionOutput(:,3);

fileID = fopen('output.txt','r');
formatSpec = '%d %d';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
sze=size(A);
%for i=1:sze(2)
%    plot()
%end
A=transpose(A);
plot(A(:,1),A(:,2))
fclose(fileID);
return



function matr = runSimulation
    REGION_SIZE=50;    
    seed=86712309;
    rng(seed);
    threatMap;  
    matr = zone;
    %createActionSet(matr);
    disp(matr);
    matr = matr(:, 1:3);
    matr(:,3) = round(matr(:,3)+1);
    sze = size(matr)
    output=[]
    colors=[]

    for i=1:sze(1)
        pop = (4000-1000)*rand(1) + 1000;

       for xpos=matr(i,1)+1:matr(i,1)+matr(i,3)-1
          for ypos = matr(i,2)+1:matr(i,2)+matr(i,3)-1
             output=[output; xpos,ypos,(pop)/( (4.2*10^-10)*( -(pop)+3000 )^3 + 2.8)]; 
          end
       end    
    end
    %hold off;
    %scatter(output(:,1), output(:,2),1,colors(:,1));
    matr=output;
    
    function threatMap
        assignin('base','NO_MAX_TARGETS',0);
        axis([0 REGION_SIZE 0 REGION_SIZE]);
        grid on; xlabel('Longitude'); ylabel('Latitude'); title('Zone locations');%grid minor;% grid MinorGridColor, 'b';
        ax = gca;
        ax.MinorGridColor = 'k';  % [R, G, B]
        ax.MinorGridAlpha = 0.2; % maximum line opacity
        ax.MinorGridLineStyle = '-';
        grid off;
        %grid minor;
        hold on;
    end

    function matr = zone
        numZones=90;
        matr=[];
        threats_x=[];
        threats_y=[];
        threats_Types=[];
        Zoning;
        %DistributeThreats;
        
        function Zoning
            CreateZones;
            %PlotZones;
                        
            function CreateZones
                    maxZoneWidth=10;
                    totalNumPriorities = 3;
                    indexOfX = 1;
                    indexOfY = 2;
                    indexOfWidth = 3;
                    indexOfHeight = 3;
                    indexOfPriority = 4;
                    NumOfVariablesPerZone = 4;
                    vectSizes = [REGION_SIZE,REGION_SIZE,maxZoneWidth,totalNumPriorities];
                    i=1;
                    while(i<(numZones+1))
                        randZone = (vectSizes.*rand(1,NumOfVariablesPerZone));
                        %use ceil on priority
                        randZone(1,indexOfX) = ceil(randZone(1,indexOfX));
                        
                        randZone(1,indexOfY) = ceil(randZone(1,indexOfY));


                        randZone(1,indexOfPriority) = 1;%ceil(randZone(1,indexOfPriority));


                        %Change width:
                        randZone(1,indexOfWidth)= (vectSizes(1,indexOfWidth)*rand(1))+2;     %Edit rand(1)+3 -> 3*rand(1) to increase zone to more meaningful size
                        %randZone(1,indexOfWidth)=randZone(1,indexOfWidth)+1;
                        %disp(randZone(1,indexOfWidth));
                        %randZone(1,indexOfWidth) = ceil(randZone(1,indexOfWidth));
                        
                        if(randZone(1,indexOfWidth)<2)
                            continue;
                        end 
                                
                        
                        %randZone(1,indexOfWidth) = randZone(1,indexOfWidth) +1;
                        %Get size variables, initialize addVect flag to true
                        sizeMatr=size(matr);
                        c=sizeMatr(1);
                        addVect = true;

                        %Check to see if the zone is outside of the grid, if so, then dont
                        %plot it
                        if((randZone(1,indexOfX)+randZone(1,indexOfWidth))>REGION_SIZE||(randZone(1,indexOfY)+randZone(1,indexOfHeight))>REGION_SIZE)
                            continue;
                        end

                        %Iterate through all the zones to check for overlap
                        for j=1:c
                            xoverlap=0;
                            yoverlap=0;

                            %Check for x overlap
                                %Is the x components of the zone to be added inside zone j?
                            if((randZone(1,indexOfX)>matr(j,indexOfX)&&randZone(1,indexOfX)<matr(j,indexOfX)+matr(j,indexOfWidth))|| (randZone(1,indexOfX)+randZone(1,3)>matr(j,indexOfX)&&randZone(1,indexOfX)+randZone(1,indexOfWidth)<matr(j,indexOfX)+matr(j,indexOfWidth)))
                                xoverlap=1;
                            end
                                %Is x components of zone j inside the zone to be added?
                            if((matr(j,indexOfX)>randZone(1,indexOfX)&&matr(j,indexOfX)<randZone(1,indexOfX)+randZone(1,indexOfWidth))|| (matr(j,indexOfX)+matr(j,indexOfWidth)>randZone(1,indexOfX)&&matr(j,indexOfX)+matr(j,indexOfWidth)<randZone(1,indexOfX)+randZone(1,indexOfWidth)))
                                xoverlap=1;
                            end

                            %Check for y overlap
                                %Is y components of the zone to be added inside zone j?
                            if((randZone(1,indexOfY)>matr(j,indexOfY)&&randZone(1,indexOfY)<matr(j,indexOfY)+matr(j,indexOfHeight))|| (randZone(1,indexOfY)+randZone(1,indexOfHeight)>matr(j,indexOfY)&&randZone(1,indexOfY)+randZone(1,indexOfHeight)<matr(j,indexOfY)+matr(j,indexOfHeight)))
                                yoverlap=1;
                            end
                                %Is y components of zone j inside the zone to be added?
                            if((matr(j,indexOfY)>randZone(1,indexOfY)&&matr(j,indexOfY)<randZone(1,indexOfY)+randZone(1,indexOfHeight))|| (matr(j,indexOfY)+matr(j,indexOfHeight)>randZone(1,indexOfY)&&matr(j,indexOfY)+matr(j,indexOfHeight)<randZone(1,indexOfY)+randZone(1,indexOfHeight)))
                                yoverlap=1;
                            end

                            %Set the addvect flag to false if there is both xoverlap and yoverlap
                            if(xoverlap&&yoverlap)
                                addVect=false;
                                break;
                            end
                                %end

                        end

                        %If addVect flag is true, then add the vector
                        if(addVect)
                            %randZone(3) = randZone(3)+1;
                            matr(i,:) = randZone;
                            i=i+1;
                        end
                    end
            end
            
            function PlotZones
                
                sizeMatr = size(matr);
                c=sizeMatr(1);

                for i=1:c
                    vect = zeros(1,4);
                    vect(1,:) = [matr(i,1:3), matr(i,3)];
                    rect=rectangle('Position',vect);
                    if matr(i,4)==3 %If priority=3, make color red
                        set(rect, 'EdgeColor', 'r');
                    elseif matr(i,4)==2 %If priority=2, make color blue
                        set(rect, 'EdgeColor', 'b');
                    elseif matr(i,4)==1 %If priority=1, make color green
                        set(rect, 'EdgeColor', 'g');
                    end
                end
                    %set(h,'Color','b');
            end
            
        end
    end

    function matr = createActionSet
       %For every "road"
        %Check if 
        
    end

end