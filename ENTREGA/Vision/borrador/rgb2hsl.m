function [H,S,L] = rgb2hsl(R,G,B)
% https://en.wikipedia.org/wiki/HSL_and_HSV
    R_ = R/255;
    G_ = G/255;
    B_ = B/255;

    M = max([R_,G_,B_]);
    m = min([R_,G_,B_]);
    C = M - m;

    if C==0
        H = 0;
    elseif M == R_
        H = 60*mod((G_-B_)/C, 6);
    elseif M == G_
        H = 60*((B_-R_)/C + 2);
    else
        H = 60*((R_-G_)/C + 4);
    end
    
    L = (M+m)/2;
    
    if L==1 || L==0
        S = 0;
    else
        S = C/(1-abs(2*L-1));
    end

end