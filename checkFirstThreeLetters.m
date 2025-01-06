function isSame = checkFirstThreeLetters(str)
    % This function checks if the first three letters of the input string are the same.
    % It returns true if they are the same, false otherwise.
    
    % Ensure the string has at least 3 characters
    if strlength(str) < 3
        error('The input string must have at least 3 characters.');
    end
    
    % Extract the first three characters
    firstThree = extractBefore(str, 4);
    
    % Check if all characters are the same
    isSame = all(firstThree == firstThree(1));
    
    % Display result
    if isSame
        disp('The first three letters are the same.');
    else
        disp('The first three letters are not the same.');
    end
end
