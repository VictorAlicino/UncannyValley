

% Function to perform Thresholding
function [output_image] = thresholding(input_image, threshold)
    [rows, columns, numberOfColorChannels] = size(input_image);
    output_image = zeros(rows, columns, numberOfColorChannels, 'uint8');
    for row = 1 : rows
        for column = 1 : columns
            if input_image(row, column) > threshold
                output_image(row, column) = 255;
            else
                output_image(row, column) = 0;
            end
        end
    end
end

% Function to perform Grayscale Conversion
function [output_image] = grayscale(input_image)
    [rows, columns, ~] = size(input_image); % Get the size of the image
    output_image = zeros(rows, columns, 'uint8'); % Preallocate output image
    for row = 1 : rows % Loop through every pixel
        % Perform Grayscale Conversion
        for column = 1 : columns % Loop through every pixel
            output_image(row, column) = 
                0.299 * input_image(row, column, 1) 
                + 0.587 * input_image(row, column, 2) 
                + 0.114 * input_image(row, column, 3);
        end
    end
end

% Function to perform Basic High Pass Filtering
function [output_image] = high_pass_filtering(input_image)
    [rows, columns, ~] = size(input_image); % Get the size of the image
    output_image = zeros(rows, columns, 'uint8'); % Preallocate output image
    for row = 2 : rows - 1 % Loop through every pixel
        for column = 2 : columns - 1 % Loop through every pixel
            % Perform High Pass Filtering
            output_image(row, column) = 
                -1 * input_image(row - 1, column - 1) 
                -1 * input_image(row - 1, column) 
                -1 * input_image(row - 1, column + 1) 
                -1 * input_image(row, column - 1) 
                + 8 * input_image(row, column) 
                -1 * input_image(row, column + 1) 
                -1 * input_image(row + 1, column - 1) 
                -1 * input_image(row + 1, column) 
                -1 * input_image(row + 1, column + 1);
        end
    end
end

% Function to perform High Reinforcement High Pass Filtering
function [output_image] = high_reinforcement_high_pass_filtering(input_image)
    [rows, columns, ~] = size(input_image); % Get the size of the image
    output_image = zeros(rows, columns, 'uint8'); % Preallocate output image
    for row = 2 : rows - 1 % Loop through every pixel
        for column = 2 : columns - 1 % Loop through every pixel
            % Perform High Reinforcement High Pass Filtering
            output_image(row, column) = 
                -1 * input_image(row - 1, column - 1) 
                -1 * input_image(row - 1, column) 
                -1 * input_image(row - 1, column + 1) 
                -1 * input_image(row, column - 1) 
                + 9 * input_image(row, column) 
                -1 * input_image(row, column + 1) 
                -1 * input_image(row + 1, column - 1) 
                -1 * input_image(row + 1, column) 
                -1 * input_image(row + 1, column + 1);
        end
    end
end