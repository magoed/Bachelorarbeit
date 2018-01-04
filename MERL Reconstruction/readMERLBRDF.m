
% Reads a MERL-type .binary file, containing a densely sampled BRDF
% Returns a 4-dimensional array (phi_d, theta_d, theta_h, channel)
function A4D = readMERLBRDF(filename)
    f = fopen(filename);
    [dims, count1] = fread(f,3,'int32');
    [vals, count2] = fread(f,'double');
    fclose(f);
    %permute(vals, [180 90 90]);
    %BRDFVals = reshape(vals,[fliplr(format.dims')]);
    %fprintf('%d %d %d \n',dims(3,1), dims(2,1), dims(1,1));
    
    %mat=[vals];
    % RESHAPE
    result = reshape(vals, [180,90,90,3]);
    result2 = permute(result,[1 3 2 4]);

    % Colorscaling
    result2(:,:,:,1) = result2(:,:,:,1)* (1.00/1500); % red scale
    result2(:,:,:,2) = result2(:,:,:,2)* (1.15/1500); % green scale
    result2(:,:,:,3) = result2(:,:,:,3)* (1.66/1500); % blue scale

    result2(result2 < 0) = -1; 
    
    A4D = result2;
end