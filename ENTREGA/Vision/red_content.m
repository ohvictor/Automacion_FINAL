function output = red_content(input)
    hsv_image = rgb2hsv(input);
    output = (hsv_image(:,:,1) < 1/12 | hsv_image(:,:,1) > 11/12) & hsv_image(:,:,2) > 1/4 & hsv_image(:,:,3) > 1/4;
end