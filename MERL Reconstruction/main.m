% fprintf('Read BRDF Database\n');
% [BRDFs, training, testing] = read_BRDF_database;
fprintf('Read training and testing data Database\n');
[training, testing] = read_BRDF_database;

fprintf('Compute the median of the training data across all m colums (of each row) of A (the training matrix)\n');
f_median = median(training,2);

fprintf('cosine-weight factor\n');
% we use 1 
w = zeros(180*90*90,1);
w(:,1) = 1;

fprintf('Compute matrix X\n');
X = zeros(180*90*90, 3 * 90);
% epsilon takes care of the input of the logarithm 
epsilon = 0.001;
for b = 1:3*90
    fprintf('%d\n', b);
    for a = 1:180*90*90
        X(a,b) = log((training(a,b)*w(a,1)+epsilon)/(f_median(a)*w(a,1)+epsilon));
    end    
end

fprintf('Compute mean mu over columns of matrix X\n');
mu = mean(X,2);

fprintf('Compute matrix Y\n');
Y = zeros(180*90*90, 3 * 90);
for b = 1:3*90
    fprintf('%d\n', b);
    for a = 1:180*90*90
        Y(a,b) = X(a,b) - mu(a,1);
    end    
end

fprintf('Compute SVD Y\n');
[U,S,V] = svd(Y,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute C
% testing = U*S*C
% pinv(U*S) * testing = C

X_r = zeros(180*90*90, 3 * 10);
for b = 1:3*10
    fprintf('%d\n', b);
    for a = 1:180*90*90
        % X_r(a,b) = U*S*C + mu(a,1);
        X_r(a,b) = testing(a,b) + mu(a,1);
    end    
end


% inverse mapping
A = zeros(180*90*90, 3 * 10);
for b = 1:3*10
    fprintf('%d\n', b);
    for a = 1:180*90*90
        A(a,b) = (exp(X_r(a,b)) * (f_median(a)*w(a,1)+epsilon) - epsilon)/(w(a,1));
    end    
end

% End
fprintf('End\n');