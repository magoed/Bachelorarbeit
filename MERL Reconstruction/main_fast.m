% fprintf('Read BRDF Database\n');
fprintf('Read training and testing data Database\n');
[training, testing] = read_BRDF_database;


fprintf('cosine-weight factor\n');
w = ones(180*90*90,1);

%% training
fprintf('Compute the median of the training data across all m colums (of each row) of A (the training matrix)\n');
f_median = median(training,2);

fprintf('Compute matrix X\n');
% epsilon takes care of the input of the logarithm 
epsilon = 0.001;
X = log((training+epsilon)./(repmat(f_median,1,270)+epsilon));

fprintf('Compute mean mu over columns of matrix X\n');
mu = mean(X,2);

fprintf('Compute matrix Y\n');
Y = X - repmat(mu,1,270);

fprintf('Compute SVD Y\n');
[U,S,V] = svd(Y,0);

%% testing
fprintf('Compute the median of the training data across all m colums (of each row) of A (the training matrix)\n');
f_median_testing = median(testing,2);

fprintf('Compute matrix X for testing\n');
X_testing = log((testing+epsilon)./(repmat(f_median_testing,1,30)+epsilon));

fprintf('Compute mean mu over columns of matrix X\n');
mu_testing = mean(X_testing,2);

fprintf('Compute matrix Y\n');
Y_testing = X_testing - repmat(mu_testing,1,30);

%% Compute C
% Y_testing = U*S*C

C = (U*S)\Y_testing;

%% Reconstruction
X_r = U*S*C + repmat(mu,1,30);
A = exp(X_r) .* (repmat(f_median,1,30)+epsilon) - epsilon;
%A = exp(X_r) .* (repmat(f_median,1,270)+epsilon) - epsilon;


%% Test
c = (U*S)\Y_testing(:,1);
X_test = U*S*c + mu;
A_test = exp(X_test) * (f_median+epsilon) - epsilon;

%% End
fprintf('End\n');