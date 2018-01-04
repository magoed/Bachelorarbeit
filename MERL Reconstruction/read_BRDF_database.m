% Reads all MERL BRDFs returns the red, green and blue BRDFs in different matrices

%function [BRDF, training_data, testing_data] = read_BRDF_database
function [training_data, testing_data] = read_BRDF_database
        % BRDF = zeros(180*90*90, 3 * 100);
        training_data = zeros(180*90*90, 3 * 90);
        testing_data = zeros(180*90*90, 3 * 10);
        
        % Order with MERL BRDFS
        file = 'C:\Users\Marc\Desktop\Bachelorarbeit\brdfs\';

        %Parse filenames
        listing = dir(file);
        count_data = 1;
        for i = 1:length(listing)
    %         fprintf('%d \n %s \n',i,listing(i).name);
            complet_file = cat(2,file,listing(i).name);
            [filepath,name,ext] = fileparts(complet_file);
            if strcmp(ext,'.binary')
    %             fprintf('%s\n',complet_file);
                A4D = readMERLBRDF(complet_file);
                
                R_col = reshape(A4D(:,:,:,1),numel(A4D(:,:,:,1)), 1);
                G_col = reshape(A4D(:,:,:,2),numel(A4D(:,:,:,2)), 1);
                B_col = reshape(A4D(:,:,:,3),numel(A4D(:,:,:,3)), 1);
                
                % BRDF(:,count_data) = R_col;
                % BRDF(:,count_data+1) = G_col;
                % BRDF(:,count_data+2) = B_col;
                
                % 90 materials for training / 10 materials for testing
                if count_data <= 90*3
                    training_data(:,count_data) = R_col;
                    training_data(:,count_data+1) = G_col;
                    training_data(:,count_data+2) = B_col;
                else
                    testing_data(:,count_data-90*3) = R_col;
                    testing_data(:,count_data+1-90*3) = G_col;
                    testing_data(:,count_data+2-90*3) = B_col;
                end
                
                fprintf('%d\n', count_data);
                count_data = count_data+3;

            end
        end    
end