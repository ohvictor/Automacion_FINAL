%% TESTING GETTING RID OF THE OUTSIDE OF THE PAPER

clear all
close all
clc

input_image = iread('.\images\testing_image_5.png');
input_image_mono = imono(input_image);


blobs = iblobs(input_image_mono, 'boundary');


size_ = size(input_image_mono);
HEIGHT  = size_(1);
WIDTH   = size_(2);

for row = 1:HEIGHT
    for col = 1:WIDTH
        %if input_image_mono.pick([row,col]) == 1
        if blobs(1).contains([row,col]) && ~blobs(2).contains([row,col])
            input_image_mono(row,col) = 100;
        end
    end
end

figure(1)
idisp(input_image_mono);
blobs.plot_boundary

%blobs(1).contains()

%% TESTING FINDING THE FOUR VERTICES OF THE RECTANGLE

clear all
close all
clc

USING_INTERP2 = 1;
USING_FITGEOTFORM2D = 2;

SHOW_LINES = false;
SHOW_TRANSFORMED = true;
TRANSFORMATION_METHOD = USING_INTERP2;

% Otra opcion: usar centroide de blobs
% ".\testing_image_rectangle_3dtransform_3.png",
for name = [".\images\testing_image_rectangle_1.png",...
        ".\images\testing_image_rectangle_3dtransform_2.png",...
        ".\images\testing_image_rectangle_3dtransform_4.png",...
        ".\images\testing_image_rectangle_3dtransform_5.png",...
        ".\images\testing_image_rectangle_3dtransform_6.png"]

    input_image = iread(name);
    input_image_only_red = input_image;
    input_image_only_red(:,:,2:3) = 0;
    input_image_mono = imono(input_image_only_red);
    threshold = max(max(input_image_mono))*0.7;
    input_image_thershold = input_image_mono > threshold;

    
    
    hough = Hough(1-input_image_thershold, 'nbins',[800,801]);
    hough.houghThresh = 1/3;
    hough.suppress = 120;
    
    if SHOW_LINES
        figure();
        idisp(input_image_thershold);
        hough.plot
    end
    
    lines = hough.lines;
    
    valid_verteces = zeros(2,0);
    for i = 1:width(lines)
        for j = i:width(lines)
            line1 = lines(i);
            line2 = lines(j);
            theta1 = line1.theta;
            theta2 = line2.theta;
            rho1 = line1.rho;
            rho2 = line2.rho;
    
            A = [sin(theta1),cos(theta1);sin(theta2),cos(theta2)];
            b = [rho1;rho2];
            if det(A) ~= 0
                xy = A\b;
                x = xy(1);
                y = xy(2);
                
                %disp(xy);
                if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
                    valid_verteces = [valid_verteces,[x;y]];

                    if SHOW_LINES
                        hold on
                        plot(x,y,"o");
                    end
                end
            end
            %valid_verteces = [valid_verteces;[i,j]];
        end
    end
    
    %figure(2);
    %hough.lines
    %figure(3);
    %mesh(hough.A)
    
    %   a---b               a'--b'
    %   |   |      =>       |   |
    %   c---d               c'--d'
    %
    % P(u',v') = [a+(b-a)(u'/200)](1-(v'/150)) + [c+(d-c)(u'/200)](v'/150)
    
    new_width = 200*2;
    new_height = 150*2;

    center = (sum(valid_verteces')/4)';
    offsets = valid_verteces-center;
    angles = atan2(offsets(2,:),offsets(1,:));
    
    ordered_verteces = [angles;valid_verteces];
    ordered_verteces = sortrows(ordered_verteces')';
    ordered_verteces = ordered_verteces(2:3,:);

    a = ordered_verteces(:,1);
    b = ordered_verteces(:,2);
    c = ordered_verteces(:,4);
    d = ordered_verteces(:,3);

    if TRANSFORMATION_METHOD == USING_INTERP2

        [Uo,Vo] = imeshgrid(new_width,new_height);
        [Ui,Vi] = imeshgrid(input_image);
        
        %ordered_valid_verteces = [sum(valid_verteces);valid_verteces;[1 2 3 4]];
        %ordered_valid_verteces = sortrows(ordered_valid_verteces')';
        %ordered_valid_verteces = valid_verteces(2:3,:);
            
        U = (a(1)+(b(1)-a(1))*Uo/new_width).*(1-Vo/new_height) + (c(1)+(d(1)-c(1))*Uo/new_width).*(Vo/new_height);
        V = (a(2)+(b(2)-a(2))*Uo/new_width).*(1-Vo/new_height) + (c(2)+(d(2)-c(2))*Uo/new_width).*(Vo/new_height);
        
        
        input_image_transformed = interp2(Ui,Vi,idouble(imono(input_image)),U,V);
    elseif TRANSFORMATION_METHOD == USING_FITGEOTFORM2D

        H = fitgeotrans(int32([a b c d])',int32([[1;1],[new_width;1],[1;new_height],[new_width;new_height]])','projective');
        [input_image_transformed, ref] = imwarp(imono(input_image),H,'OutputView',imref2d(size(imono(input_image))));
    end
    
    if SHOW_TRANSFORMED
        hold off
        figure()
        idisp(input_image_transformed);
    end

end


%% ESTUDIANDO LineFeature

%rho1 = 0;
%theta1 = 0;
%strength1 = 1;
%line1 = LineFeature(rho1,theta1,strength1);
%line1.plot

%           rho     theta   strength
LineFeature(0,      0,      1).plot;
LineFeature(sqrt(2),      pi/4,   1).plot;
%LineFeature(sqrt(2),      -pi/4,      1).plot;
%LineFeature(10,     0,      1).plot;
%LineFeature(-5,     0,      1).plot;

% sin(theta) x + cos(theta) y = rho
% Ax=b, ver si puedo invertir A
